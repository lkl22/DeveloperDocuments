# 缩减、混淆处理和优化应用

为了尽可能减小应用的大小，您应在发布 build 中启用缩减功能来移除不使用的代码和资源。启用缩减功能后，您还会受益于两项功能，一项是混淆处理功能，该功能会缩短应用的类和成员的名称；另一项是优化功能，该功能会采用更积极的策略来进一步减小应用的大小。本页介绍 R8 如何为项目执行这些编译时任务，以及您如何对这些任务进行自定义。

当您使用 `Android Gradle` 插件 3.4.0 或更高版本构建项目时，该插件不再使用 ProGuard 执行编译时代码优化，而是与 R8 编译器协同工作，处理以下编译时任务：

* **代码缩减（即摇树优化）**：从应用及其库依赖项中检测并安全地移除不使用的类、字段、方法和属性（这使其成为了一个对于规避 64k 引用限制非常有用的工具）。例如，如果您仅使用某个库依赖项的少数几个 API，那么缩减功能可以识别应用不使用的库代码并仅从应用中移除这部分代码。
* **资源缩减**：从封装应用中移除不使用的资源，包括应用库依赖项中不使用的资源。此功能可与代码缩减功能结合使用，这样一来，移除不使用的代码后，也可以安全地移除不再引用的所有资源。
* **混淆**：缩短类和成员的名称，从而减小 DEX 文件的大小。
* **优化**：检查并重写代码，以进一步减小应用的 DEX 文件的大小。例如，如果 R8 检测到从未采用过给定 if/else 语句的 else {} 分支，则会移除 else {} 分支的代码。

默认情况下，在构建应用的发布版本时，R8 会自动执行上述编译时任务。不过，您也可以停用某些任务或通过 ProGuard 规则文件自定义 R8 的行为。事实上，**R8 支持所有现有 ProGuard 规则文件**，因此您在更新 Android Gradle 插件以使用 R8 时，无需更改现有规则。

* [启用压缩、混淆和优化功能](#enable)
* [R8 配置文件](#configuration-files)
  * [添加其他配置](#add-configuration)
* [缩减代码](#shrink-code)
  * [自定义要保留的代码](#keep-code)
* [移除原生库](#strip-native-libraries)
  * [原生代码崩溃支持](#native-crash-support)
* [缩减资源](#shrink-resources)
  * [自定义要保留的资源](#keep-resources)
  * [启用严格引用检查](#strict-reference-checks)
  * [移除未使用的备用资源](#unused-alt-resources)
  * [合并重复资源](#merge-resources)
* [对代码进行混淆处理](#obfuscate)
  * [解码经过混淆处理的堆栈轨迹](#decode-stack-trace)
* [代码优化](#optimization)
  * [启用更积极的优化](#full-mode)
* [排查 R8 问题](#troubleshoot)
  * [生成移除的（或保留的）代码的报告](#usage)
  * [排查资源缩减问题](#troubleshoot-resource-shrink)
* [参考文献](#参考文献)

## <a name="enable">启用压缩、混淆和优化功能<a/>

当您使用 Android Studio 3.4 或 Android Gradle 插件 3.4.0 及更高版本时，R8 是默认编译器，用于将项目的 Java 字节码转换为在 Android 平台上运行的 DEX 格式。不过，当您使用 Android Studio 创建新项目时，缩减、混淆处理和代码优化功能默认处于停用状态。这是因为，这些编译时优化功能会增加项目的构建时间，而且如果您没有充分`自定义要保留的代码`，还可能会引入错误。

因此，在构建应用的最终版本（也就是在发布应用之前测试的版本）时，最好启用这些编译时任务。如需启用缩减、混淆处理和优化功能，请在项目级 build.gradle 文件中添加以下代码。

```groovy
android {
    buildTypes {
        release {
            // Enables code shrinking, obfuscation, and optimization for only
            // your project's release build type.
            minifyEnabled true

            // Enables resource shrinking, which is performed by the
            // Android Gradle plugin.
            shrinkResources true

            // Includes the default ProGuard rules files that are packaged with
            // the Android Gradle plugin. To learn more, go to the section about
            // R8 configuration files.
            proguardFiles getDefaultProguardFile(
                    'proguard-android-optimize.txt'),
                    'proguard-rules.pro'
        }
    }
    ...
}
```

## <a name="configuration-files">R8 配置文件<a/>

R8 使用 ProGuard 规则文件来修改其默认行为并更好地了解应用的结构，比如充当应用代码入口点的类。虽然您可以修改其中一些规则文件，但某些规则可能由编译时工具（如 AAPT2）自动生成，或从应用的库依赖项继承而来。下表介绍了 R8 使用的 ProGuard 规则文件的来源。

|来源	|位置	|说明
|---|---|---
|Android Studio	|\<module-dir>/proguard-rules.pro|	当您使用 Android Studio 创建新模块时，Android Studio 会在该模块的根目录中创建 `proguard-rules.pro` 文件。<br/><br/>默认情况下，此文件不会应用任何规则。因此，请在此处添加您自己的 ProGuard 规则，比如自定义保留规则。
|Android Gradle 插件	|由 Android Gradle 插件在编译时生成。	|Android Gradle 插件会生成 proguard-android-optimize.txt（其中包含了对大多数 Android 项目都有用的规则），并启用 @Keep* 注解。<br/><br/>默认情况下，使用 Android Studio 创建新模块时，模块级 build.gradle 文件会将此规则文件纳入到您的发布 build 中。<br/><br/>注意：虽然 Android Gradle 插件包含额外的预定义 ProGuard 规则文件，但建议您使用 `proguard-android-optimize.txt`。
|库依赖项	|AAR 库：\<library-dir>/proguard.txt<br/><br/>JAR 库：\<library-dir>/META-INF/proguard/ | 如果某个 AAR 库是使用它自己的 ProGuard 规则文件发布的，并且您将该 AAR 库作为编译时依赖项纳入到项目中，那么 R8 在编译项目时会自动应用其规则。<br/><br/>如果 AAR 库需要某些保留规则才能正常运行，那么使用该库随附的规则文件将非常有用。也就是说，库开发者已经为您执行了问题排查步骤。<br/><br/>不过，请注意，**由于 ProGuard 规则是累加的，因此 AAR 库依赖项包含的某些规则无法移除，并且可能会影响对应用其他部分的编译**。例如，如果某个库包含停用代码优化功能的规则，该规则会针对整个项目停用优化功能。
|Android 资源打包工具 2 (AAPT2)	|使用 minifyEnabled true 构建项目后：\<module-dir>/build/intermediates/proguard-rules/debug/aapt_rules.txt	|AAPT2 会根据对应用清单中的类、布局及其他应用资源的引用，生成保留规则。例如，AAPT2 会为您在应用清单中注册为入口点的每个 Activity 添加一个保留规则。
|自定义配置文件	|默认情况下，当您使用 Android Studio 创建新模块时，IDE 会创建 \<module-dir>/proguard-rules.pro，以便您添加自己的规则。	|您可以添加其他配置，R8 会在编译时应用这些配置。

如果您将 `minifyEnabled` 属性设为 true，R8 会将来自上述所有可用来源的规则组合在一起。在您排查 R8 问题时需要谨记这一点，因为其他编译时依赖项（如库依赖项）可能会引入您不了解的 R8 行为变化。

> 如需输出 R8 在构建项目时应用的所有规则的完整报告，请将以下代码添加到模块的 `proguard-rules.pro` 文件中：

```proguard
// You can specify any path and filename.
-printconfiguration ~/tmp/full-r8-config.txt
```

### <a name="add-configuration">添加其他配置<a/>

当您使用 Android Studio 创建新项目或模块时，IDE 会创建一个 `<module-dir>/proguard-rules.pro` 文件，以便您添加自己的规则。此外，您还可以通过将相应文件添加到模块的 `build.gradle` 文件的 `proguardFiles` 属性中，从其他文件添加额外的规则。

例如，您可以通过在相应的 `productFlavor` 代码块中再添加一个 `proguardFiles` 属性来添加每个构建变体专用的规则。以下 Gradle 文件会将 `flavor2-rules.pro` 添加到 `flavor2` 产品变种中。现在，`flavor2` 使用全部三个 ProGuard 规则，因为还应用了来自 `release` 代码块的规则。

```groovy
android {
    ...
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles
                getDefaultProguardFile('proguard-android-optimize.txt'),
                // List additional ProGuard rules for the given build type here. By default,
                // Android Studio creates and includes an empty rules file for you (located
                // at the root directory of each module).
                'proguard-rules.pro'
        }
    }
    flavorDimensions "version"
    productFlavors {
        flavor1 {
            ...
        }
        flavor2 {
            proguardFile 'flavor2-rules.pro'
        }
    }
}
```

## <a name="shrink-code">缩减代码<a/>

如果将 `minifyEnabled` 属性设为 true，系统会默认启用 R8 代码缩减功能。

**代码缩减**（也称为“摇树优化”）是指移除 R8 确定在运行时不需要的代码的过程。此过程可以大大减小应用的大小，例如，当您的应用包含许多库依赖项，但只使用它们的一小部分功能时。

为了缩减应用的代码，R8 首先会根据组合的配置文件集确定应用代码的所有入口点。这些入口点包括 Android 平台可用来打开应用的 Activity 或服务的所有类。从每个入口点开始，R8 会检查应用的代码来构建一张图表，列出应用在运行时可能会访问的所有方法、成员变量和其他类。系统会将与该图表没有关联的代码视为执行不到的代码，并可能会从应用中移除该代码。

图 1 显示了一个具有运行时库依赖项的应用。R8 通过检查应用的代码，确定可以从 `MainActivity.class` 入口点执行到的 `foo()`、`faz()` 和 `bar()` 方法。不过，您的应用从未在运行时使用过 `OkayApi.class` 类或其 `baz()` 方法，因此 R8 会在缩减应用时移除该代码。

![](shrinkCode/imgs/tree-shaking.png)
图 1. 编译时，R8 会根据项目的组合保留规则构建一张图表，用于确定执行不到的代码。

R8 通过项目的 R8 配置文件中的 `-keep` 规则确定入口点。也就是说，保留规则指定 R8 在缩减应用时不应舍弃的类，R8 将这些类视为应用的可能入口点。Android Gradle 插件和 AAPT2 会自动为您生成大多数应用项目（如应用的 Activity、视图和服务）所需的保留规则。不过，如果您需要使用其他保留规则来自定义此默认行为，请参阅介绍如何自定义要保留的代码的部分。

如果您只想减小应用资源的大小，请跳到介绍如何缩减资源的部分。

### <a name="keep-code">自定义要保留的代码<a/>

在大多数情况下，如要让 R8 仅移除不使用的代码，使用默认的 ProGuard 规则文件 (`proguard-android-optimize.txt`) 就已足够。不过，在某些情况下，R8 很难做出正确判断，因而可能会移除应用实际上需要的代码。下面列举了几个示例，说明它在什么情况下可能会错误地移除代码：

* 当应用通过 Java 原生接口 (JNI) 调用方法时
* 当您的应用在运行时查询代码时（如使用反射）

> 通过测试应用应该可以发现因错误移除代码而导致的错误，但您也可以通过[生成已移除代码的报告](#usage)检查移除了哪些代码。

如需修复错误并强制 R8 保留某些代码，请在 ProGuard 规则文件中添加 `-keep` 代码行。例如：

```proguard
-keep public class MyClass
```

或者，您也可以为要保留的代码添加 `@Keep` 注解。在类上添加 `@Keep` 可按原样保留整个类。在方法或字段上添加该注释，将使该方法/字段（及其名称）以及类名称保持不变。请注意，只有在使用 `AndroidX` 注解库且您添加 Android Gradle 插件随附的 ProGuard 规则文件时，此注解才可用。有关详情，请参阅介绍如何启用缩减功能的部分。

在使用 `-keep` 选项时，有许多注意事项；如需详细了解如何自定义规则文件，请参阅 ProGuard 手册。[问题排查](https://www.guardsquare.com/manual/troubleshooting/troubleshooting)部分简要介绍了移除代码后您可能会遇到的其他常见问题。

## <a name="strip-native-libraries">移除原生库<a/>

默认情况下，原生代码库已从应用的发布 build 中移除。此移除操作包括移除应用所使用的所有原生库中包含的符号表及调试信息。移除原生代码库会显著缩减大小；但是，由于缺少信息（例如类和函数名称），无法诊断 Google Play 管理中心内的崩溃问题。

### <a name="native-crash-support">原生代码崩溃支持<a/>

Google Play 管理中心会在 `Android Vitals` 下报告原生代码崩溃问题。只需几个步骤，即可为应用生成并上传原生代码调试符号文件。此文件可在 `Android Vitals` 中启用经过符号化解析的原生代码崩溃堆栈轨迹（包括类和函数名称），来帮助您在生产环境中调试应用。这些步骤因项目中使用的 Android Gradle 插件版本和项目的构建输出而有所不同。

注意：如需自行恢复崩溃报告中的符号名称，请使用 Android NDK 随附的 ndk-stack 工具。

#### Android Gradle 插件版本 4.1 或更高版本

如果您的项目构建的是 Android App Bundle，您可以在其中自动添加原生代码调试符号文件。如需在发布 build 中添加该文件，请将以下代码添加到应用的 `build.gradle` 文件中：

```groovy
android.buildTypes.release.ndk.debugSymbolLevel = { SYMBOL_TABLE | FULL }
```

从以下调试符号级别中进行选择：

* 使用 `SYMBOL_TABLE` 在 Play 管理中心的符号化解析后的堆栈轨迹中获取函数名称。此级别支持 Tombstone。
* 使用 `FULL` 在 Play 管理中心的符号化解析后的堆栈轨迹中获取函数名称、文件和行号。

> 注意：原生代码调试符号文件的大小上限为 300 MB。如果调试符号占用空间过大，请使用 `SYMBOL_TABLE` 而不是 `FULL` 缩减文件大小。

如果您的项目构建的是 APK，请使用之前显示的 build.gradle 构建设置，以单独生成原生代码调试符号文件。手动将原生代码调试符号文件上传到 Google Play 管理中心。在构建流程中，Android Gradle 插件会在以下项目位置输出此文件：

```groovy
app/build/outputs/native-debug-symbols/variant-name/native-debug-symbols.zip
```

#### Android Gradle 插件版本 4.0 或更低版本（及其他构建系统）

在 APK 或 Android App Bundle 构建流程中，Android Gradle 插件会在项目目录中保留未移除的库的副本。该目录结构类似于以下结构：

```
app/build/intermediates/cmake/universal/release/obj/
├── armeabi-v7a/
│   ├── libgameengine.so
│   ├── libothercode.so
│   └── libvideocodec.so
├── arm64-v8a/
│   ├── libgameengine.so
│   ├── libothercode.so
│   └── libvideocodec.so
├── x86/
│   ├── libgameengine.so
│   ├── libothercode.so
│   └── libvideocodec.so
└── x86_64/
    ├── libgameengine.so
    ├── libothercode.so
    └── libvideocodec.so
```

> 注意：如果您使用的是其他构建系统，可以对其进行修改，以便将未移除的库存储在采用所需结构的目录中。

1. 压缩以下目录的内容：

```
$ cd app/build/intermediates/cmake/universal/release/obj
$ zip -r symbols.zip .
```

2. 手动将 `symbols.zip` 文件上传到 Google Play 管理中心。

> 注意：调试符号文件的大小上限为 300 MB。如果文件过大，可能是因为 .so 文件包含符号表（函数名称）以及 DWARF 调试信息（文件名和代码行）。无需使用这些内容即可对代码进行符号化处理。您可以通过运行以下命令将这些内容移除：
> `$OBJCOPY --strip-debug lib.so lib.so.sym`
> 其中，$OBJCOPY 指向您要移除的特定 ABI 版本（例如，ndk-bundle/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-objcopy）。

## <a name="shrink-resources">缩减资源<a/>

资源缩减只有在与代码缩减配合使用时才能发挥作用。在代码缩减器移除所有不使用的代码后，资源缩减器便可确定应用仍要使用的资源，当您添加包含资源的代码库时尤其如此。您必须移除不使用的库代码，使库资源变为未引用资源，因而可由资源缩减器移除。

如需启用资源缩减功能，请将 `build.gradle` 文件中的 `shrinkResources` 属性（若为代码缩减，则还包括 `minifyEnabled`）设为 `true`。例如：

```groovy
android {
    ...
    buildTypes {
        release {
            shrinkResources true
            minifyEnabled true
            proguardFiles
                getDefaultProguardFile('proguard-android.txt'),
                'proguard-rules.pro'
        }
    }
}
```

如果您尚未使用用于缩减代码的 `minifyEnabled` 构建应用，请先尝试使用它，然后再启用 `shrinkResources`，因为您可能需要先修改 `proguard-rules.pro` 文件以保留动态创建或调用的类或方法，然后再开始移除资源。

### <a name="keep-resources">自定义要保留的资源<a/>

如果您有想要保留或舍弃的特定资源，请在项目中创建一个包含 `<resources>` 标记的 XML 文件，并在 `tools:keep` 属性中指定每个要保留的资源，在 `tools:discard` 属性中指定每个要舍弃的资源。**这两个属性都接受以逗号分隔的资源名称列表。您可以将星号字符用作通配符**。

例如：

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@layout/l_used*_c,@layout/l_used_a,@layout/l_used_b*"
    tools:discard="@layout/unused2" />
```

将该文件保存在项目资源中，例如，保存在 `res/raw/keep.xml` 中。构建系统不会将此文件打包到 APK 中。

指定要舍弃的资源可能看似没有必要，因为您本可将它们删除，但在使用构建变体时，这样做可能很有用。例如，当您知道某个给定资源看似会在代码中使用（因此不会被缩减器移除），而实际不会用于给定构建变体时，就可以将所有资源放入通用项目目录中，然后为每个构建变体创建一个不同的 `keep.xml` 文件。构建工具也可能会将某个资源错误地识别为需要的资源，这可能是因为编译器会以内嵌方式添加资源 ID，而如若真正引用的资源 ID 恰巧与代码中的某个整数值相同，资源分析器可能会分辨不出两者的区别。

### <a name="strict-reference-checks">启用严格引用检查<a/>

通常，资源缩减器可以准确地判断是否使用了某个资源。不过，如果您的代码会调用 [Resources.getIdentifier()](https://developer.android.google.cn/reference/android/content/res/Resources#getIdentifier(java.lang.String,%20java.lang.String,%20java.lang.String))（或者您的任何库会执行此调用，例如 `AppCompat` 库便会执行此调用），这意味着您的代码将根据动态生成的字符串查询资源名称。当您启用严格引用检查时，资源缩减器在默认情况下会采取保护行为，将所有具有匹配名称格式的资源标记为可能已使用，无法移除。

例如，以下代码会将所有带 `img_` 前缀的资源标记为已使用。

```java
String name = String.format("img_%1d", angle + 1);
res = getResources().getIdentifier(name, "drawable", getPackageName());
```

资源缩减器还会查看代码中的所有字符串常量以及各种 `res/raw/` 资源，以查找格式类似于 `file:///android_res/drawable//ic_plus_anim_016.png` 的资源网址。如果它找到与此类似的字符串，或找到其他看似可用来构建与此类似的网址的字符串，则不会将它们移除。

这些是默认情况下启用的安全缩减模式的示例。不过，您可以停用这种“防患于未然”的处理方式，指定资源缩减器只保留确定要使用的资源。为此，您可以将 `keep.xml` 文件中的 `shrinkMode` 设为 `strict`，如下所示：

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:shrinkMode="strict" />
```

如果您确实启用了严格缩减模式，并且您的代码也通过动态生成的字符串引用资源（如上所示），那么您必须使用 `tools:keep` 属性手动保留这些资源。

### <a name="unused-alt-resources">移除未使用的备用资源<a/>

Gradle 资源缩减器只会移除未由应用代码引用的资源，这意味着，它不会移除用于不同设备配置的[备用资源](https://developer.android.google.cn/guide/topics/resources/providing-resources#AlternativeResources)。如有必要，您可以使用 Android Gradle 插件的 `resConfigs` 属性移除应用不需要的备用资源文件。

例如，如果您使用的是包含语言资源的库（如 AppCompat 或 Google Play 服务），那么您的 APK 中将包含这些库中消息的所有已翻译语言的字符串，而无论应用的其余部分是否翻译为相同的语言。如果您只想保留应用正式支持的语言，则可以使用 `resConfig` 属性指定这些语言。系统会移除未指定语言的所有资源。

以下代码段展示了如何设置只保留英语和法语的语言资源：

```groovy
android {
    defaultConfig {
        ...
        resConfigs "en", "fr"
    }
}
```

同样，您也可以通过构建多个 APK 并使每个 APK 对应不同的设备配置，自定义要包含在 APK 中的屏幕密度或 ABI 资源。

### <a name="merge-resources">合并重复资源<a/>

默认情况下，Gradle 还会合并同名的资源，如可能位于不同资源文件夹中的同名可绘制对象。这一行为不受 `shrinkResources` 属性控制，也无法停用，因为当多个资源与代码查询的名称匹配时，有必要利用这一行为避免错误。

**只有在两个或更多个文件具有完全相同的资源名称、类型和限定符时，才会进行资源合并**。Gradle 会在重复项中选择它认为最合适的文件（根据下述优先顺序），并且只将这一个资源传递给 AAPT，以便在 APK 文件中分发。

Gradle 会在以下位置查找重复资源：

* 与主源代码集关联的主资源，一般位于 `src/main/res/` 中。
* 变体叠加，来自构建类型和构建变种。
* 库项目依赖项。

Gradle 会按以下级联优先顺序合并重复资源：

> 依赖项 → 主资源 → 构建变种 → 构建类型

例如，如果某个重复资源同时出现在主资源和构建变种中，Gradle 会选择构建变种中的资源。

如果完全相同的资源出现在同一源代码集中，Gradle 无法合并它们，并且会发出资源合并错误。如果您在 `build.gradle` 文件的 `sourceSet` 属性中定义了多个源代码集，就可能会发生这种情况。例如，如果 `src/main/res/` 和 `src/main/res2/` 包含完全相同的资源，就可能会发生这种情况。

## <a name="obfuscate">对代码进行混淆处理<a/>

混淆处理的目的是通过缩短应用的类、方法和字段的名称来缩减应用的大小。下面是使用 R8 进行混淆处理的一个示例：

```
androidx.appcompat.app.ActionBarDrawerToggle$DelegateProvider -> a.a.a.b:
androidx.appcompat.app.AlertController -> androidx.appcompat.app.AlertController:
    android.content.Context mContext -> a
    int mListItemLayout -> O
    int mViewSpacingRight -> l
    android.widget.Button mButtonNeutral -> w
    int mMultiChoiceItemLayout -> M
    boolean mShowTitle -> P
    int mViewSpacingLeft -> j
    int mButtonPanelSideLayout -> K
```

虽然混淆处理不会从应用中移除代码，但如果应用的 DEX 文件将许多类、方法和字段编入索引，那么混淆处理将可以显著缩减应用的大小。不过，由于混淆处理会对代码的不同部分进行重命名，因此在执行某些任务（如检查堆栈轨迹）时需要使用额外的工具。如需了解混淆处理后的堆栈轨迹，请参阅下一个部分，其中介绍了如何解码经过混淆处理的堆栈轨迹。

此外，如果您的代码依赖于应用的方法和类的可预测命名（例如，使用反射时），您应该将相应签名视为入口点并为其指定保留规则，如介绍如何[自定义要保留的代码](#keep-code)的部分中所述。这些保留规则会告知 R8 不仅要在应用的最终 DEX 中保留该代码，而且还要保留其原始命名。

### <a name="decode-stack-trace">解码经过混淆处理的堆栈轨迹<a/>

R8 对代码进行混淆处理后，理解堆栈轨迹的难度将会极大增加，因为类和方法的名称可能有变化。除了重命名之外，R8 还可能会更改出现在堆栈轨迹中的行号，以便在写入 DEX 文件时进一步缩减大小。幸运的是，R8 在每次运行时都会创建一个 `mapping.txt` 文件，其中列出了经过混淆处理的类、方法和字段的名称与原始名称的映射关系。此映射文件还包含用于将行号映射回原始源文件行号的信息。R8 会将此文件保存在 `<module-name>/build/outputs/mapping/<build-type>/` 目录中。

> 注意：您每次构建项目时都会覆盖 R8 生成的 mapping.txt 文件，因此您每次发布新版本时都要注意保存一个该文件的副本。通过为每个发布 build 保留一个 mapping.txt 文件的副本，您可以在用户提交来自旧版应用的经过混淆处理的堆栈轨迹时，调试相关问题。

为确保跟踪还原堆栈轨迹清楚明确，您应将以下保留规则添加到模块的 `proguard-rules.pro` 文件中：

```
-keepattributes LineNumberTable,SourceFile
```

需要 `LineNumberTable` 属性，以消除方法内经过优化的位置之间的歧义。如需获取在虚拟机或设备上的堆栈轨迹中输出的行号，则必须使用 `SourceFile` 属性。

在 Google Play 上发布应用时，您可以上传每个 APK 版本对应的 `mapping.txt` 文件。然后，Google Play 会根据用户报告的问题对传入的堆栈轨迹进行去混淆处理，以便您可以在 Play 管理中心查看这些堆栈轨迹。如需了解详情，请参阅介绍如何[对崩溃堆栈轨迹进行去混淆处理](https://support.google.com/googleplay/android-developer/answer/6295281)的帮助中心文章。

## <a name="optimization">代码优化<a/>

为了进一步缩减应用，R8 会在更深的层次上检查代码，以移除更多不使用的代码，或者在可能的情况下重写代码，以使其更简洁。下面是此类优化的几个示例：

* 如果您的代码从未采用过给定 `if/else` 语句的 `else {}` 分支，R8 可能会移除 `else {}` 分支的代码。
* 如果您的代码只在一个位置调用某个方法，R8 可能会移除该方法并将其内嵌在这一个调用点。
* 如果 R8 确定某个类只有一个唯一子类且该类本身未实例化（例如，一个仅由一个具体实现类使用的抽象基类），它就可以将这两个类组合在一起并从应用中移除一个类。
* 如需了解详情，请阅读 Jake Wharton 撰写的[关于 R8 优化的博文](https://jakewharton.com/blog/)。

R8 不允许您停用或启用离散优化，也不允许您修改优化的行为。事实上，R8 会忽略试图修改默认优化行为的所有 ProGuard 规则，例如 `-optimizations` 和 `-optimizationpasses`。此限制很重要，因为随着 R8 的不断改进，维护标准的优化行为有助于 Android Studio 团队轻松排查并解决您可能遇到的任何问题。

### <a name="full-mode">启用更积极的优化<a/>

R8 包含一组额外的优化功能，这些功能在默认情况下处于停用状态。您可以通过在项目的 `gradle.properties` 文件中添加以下代码来启用这些额外的优化功能：

```
android.enableR8.fullMode=true
```

这些额外的优化功能会使 R8 的行为与 ProGuard 不同，因此可能会需要您添加额外的 ProGuard 规则，以避免运行时问题。例如，假设您的代码通过 Java Reflection API 引用一个类。默认情况下，R8 会假设您打算在运行时检查和操纵该类的对象（即使您的代码实际上并不这样做），因此它会自动保留该类及其静态初始化程序。

不过，在使用“完整模式”时，R8 不会做出这种假设，如果 R8 断定您的代码从不在运行时使用该类，它会将该类从应用的最终 DEX 中移除。也就是说，如果您要保留该类及其静态初始化程序，则需要在规则文件中添加相应的保留规则。

如果您在使用 R8 的“完整模式”时遇到任何问题，请参阅 [R8 常见问题解答页面](https://r8.googlesource.com/r8/+/refs/heads/master/compatibility-faq.md)，寻找可能的解决方案。

## <a name="troubleshoot">排查 R8 问题<a/>

本部分介绍在使用 R8 启用代码缩减、混淆和优化功能时排查问题的一些策略。如果您在下文中找不到相关问题的解决方案，您还应参阅 [R8 常见问题解答页面](https://r8.googlesource.com/r8/+/refs/heads/master/compatibility-faq.md)和 [ProGuard 的问题排查指南](https://www.guardsquare.com/en/products/proguard/manual/troubleshooting)。

### <a name="usage">生成移除的（或保留的）代码的报告<a/>

为了便于排查特定的 R8 问题，建议您查看 R8 从您的应用中移除的所有代码的报告。请针对要为其生成此报告的每个模块，将 `-printusage <output-dir>/usage.txt` 添加到您的自定义规则文件中。当您在启用 R8 的情况下构建应用时，R8 会按照您指定的路径和文件名输出报告。移除的代码的报告与以下输出类似：

```
androidx.drawerlayout.R$attr
androidx.vectordrawable.R
androidx.appcompat.app.AppCompatDelegateImpl
    public void setSupportActionBar(androidx.appcompat.widget.Toolbar)
    public boolean hasWindowFeature(int)
    public void setHandleNativeActionModesEnabled(boolean)
    android.view.ViewGroup getSubDecor()
    public void setLocalNightMode(int)
    final androidx.appcompat.app.AppCompatDelegateImpl$AutoNightModeManager getAutoNightModeManager()
    public final androidx.appcompat.app.ActionBarDrawerToggle$Delegate getDrawerToggleDelegate()
    private static final boolean DEBUG
    private static final java.lang.String KEY_LOCAL_NIGHT_MODE
    static final java.lang.String EXCEPTION_HANDLER_MESSAGE_SUFFIX
...
```

如果您要查看 R8 根据项目的保留规则确定的入口点的报告，请将 `-printseeds <output-dir>/seeds.txt` 添加到您的自定义规则文件中。当您在启用 R8 的情况下构建应用时，R8 会按照您指定的路径和文件名输出报告。保留的入口点的报告与以下输出类似：

```
com.example.myapplication.MainActivity
androidx.appcompat.R$layout: int abc_action_menu_item_layout
androidx.appcompat.R$attr: int activityChooserViewStyle
androidx.appcompat.R$styleable: int MenuItem_android_id
androidx.appcompat.R$styleable: int[] CoordinatorLayout_Layout
androidx.lifecycle.FullLifecycleObserverAdapter
...
```

### <a name="troubleshoot-resource-shrink">排查资源缩减问题<a/>

当您缩减资源时，Build  窗口会显示从 APK 中移除的资源的摘要。（您需要先点击窗口左侧的 `Toggle view` 图标 ，以显示 Gradle 输出的详细文本。）例如：

```
:android:shrinkDebugResources
Removed unused resources: Binary resource data reduced from 2570KB to 1711KB: Removed 33%
:android:validateDebugSigning
```

Gradle 还会在 `<module-name>/build/outputs/mapping/release/`（ProGuard 输出文件所在的文件夹）中创建一个名为 `resources.txt` 的诊断文件。此文件包含一些详细信息，比如，哪些资源引用了其他资源，哪些资源在使用，哪些资源被移除。

例如，如需了解您的 APK 为何仍包含 `@drawable/ic_plus_anim_016`，请打开 `resources.txt` 文件并搜索该文件名。您可能会发现，有其他资源引用了它，如下所示：

```
16:25:48.005 [QUIET] [system.out] &#64;drawable/add_schedule_fab_icon_anim : reachable=true
16:25:48.009 [QUIET] [system.out]     &#64;drawable/ic_plus_anim_016
```

您现在需要知道为什么可执行到 `@drawable/add_schedule_fab_icon_anim`，如果您向上搜索，就会发现`“The root reachable resources are:”`下列有该资源。这意味着存在对 `add_schedule_fab_icon_anim` 的代码引用（即在可执行到的代码中找到了其 R.drawable ID）。

如果您使用的不是严格检查，当存在看似可用于为动态加载资源构建资源名称的字符串常量时，就可将资源 ID 标记为“可执行到”。在这种情况下，如果您在构建输出中搜索资源名称，可能会发现如下消息：

```
10:32:50.590 [QUIET] [system.out] Marking drawable:ic_plus_anim_016:2130837506
    used because it format-string matches string pool constant ic_plus_anim_%1$d.
```

如果您看到一个这样的字符串，并且确定该字符串未用于动态加载给定资源，就可以使用 `tools:discard` 属性通知构建系统将其移除，具体如介绍如何自定义要保留的资源部分中所述。

## 参考文献

[缩减、混淆处理和优化应用](https://developer.android.google.cn/studio/build/shrink-code)

[https://firebase.google.cn/docs/android/setup](https://firebase.google.cn/docs/android/setup)
