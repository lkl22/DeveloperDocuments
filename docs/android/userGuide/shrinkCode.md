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








## 参考文献

[缩减、混淆处理和优化应用](https://developer.android.google.cn/studio/build/shrink-code)