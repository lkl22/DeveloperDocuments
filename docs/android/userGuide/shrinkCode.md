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
































## 参考文献

[缩减、混淆处理和优化应用](https://developer.android.google.cn/studio/build/shrink-code)