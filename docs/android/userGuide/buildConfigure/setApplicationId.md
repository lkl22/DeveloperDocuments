# 设置应用 ID

每个 Android 应用均有一个唯一的应用 ID，像 Java 软件包名称一样，例如 com.example.myapp。此 ID 可以在设备上和 Google Play 商店中对您的应用进行唯一标识。如果您要上传新版本的应用，应用 ID（以及用于为其签名的证书）必须与原始 APK 相同。如果您更改了应用 ID，Google Play 商店会将该 APK 视为完全不同的应用。**因此，发布您的应用后，绝不应更改应用 ID**。

您的应用 ID 通过模块的 build.gradle 文件中的 applicationId 属性定义，如下所示：

```groovy
android {
    defaultConfig {
        applicationId "com.example.myapp"
        minSdkVersion 15
        targetSdkVersion 24
        versionCode 1
        versionName "1.0"
    }
}
```

当您在 Android Studio 中创建新项目时，applicationId 与您在设置期间选择的 Java 样式软件包名称完全一致。不过，除了这一点，应用 ID 和软件包名称彼此无关。您可以更改代码的软件包名称（代码命名空间），这不会影响应用 ID，反之亦然（但同样，发布您的应用后，不得更改应用 ID）。


虽然应用 ID 看起来就像传统的 Java 软件包名称一样，但应用 ID 的命名规则限制性更强一些：

* 必须至少包含两段（一个或多个圆点）
* 每段必须以字母开头
* 所有字符必须为字母、数字或下划线 [a-zA-Z0-9_]

注意：应用 ID 过去直接关联到代码的软件包名称；所以，有些 Android API 会在其方法名称和参数名称中使用“_package name_”一词，**但这实际上是您的应用 ID**。例如，`Context.getPackageName()` 方法会返回您的应用 ID。无论何时都不需要在应用代码以外分享代码的真实软件包名称。

## 更改用于构建变体的应用 ID

当您为应用构建 APK 时，构建工具会使用 `build.gradle` 文件的 _defaultConfig_ 块中定义的应用 ID 标记 APK（如下所示）。不过，如果您要创建不同版本的应用，让其在 Google Play 商店中显示为单独的详情（如“free”和“pro”版本），则需要创建单独的[构建变体](./configureBuildVariants.md)，这些变体各自具有不同的应用 ID。

在这种情况下，每个构建变体应定义为单独的[产品变种](./configureBuildVariants.md)。对于 `productFlavors` 块中的每个变种，您可以重新定义 `applicationId` 属性，也可以使用 `applicationIdSuffix` 在默认的应用 ID 上追加一段，如下所示：

```groovy
android {
    defaultConfig {
        applicationId "com.example.myapp"
    }
    productFlavors {
        free {
            applicationIdSuffix ".free"
        }
        pro {
            applicationIdSuffix ".pro"
        }
    }
}
```

这样，“free”产品变种的应用 ID 就是“com.example.myapp.free”。

您也可以根据自己的构建类型使用 `applicationIdSuffix` 追加一段，如下所示：

```groovy
android {
    ...
    buildTypes {
        debug {
            applicationIdSuffix ".debug"
        }
    }
}
```

由于 Gradle 会在产品变种后面应用构建类型配置，因此“free debug”构建变体的应用 ID 现在是“com.example.myapp.free.debug”。如果您希望同一设备上同时具有调试版本和发布版本，这会很有用，因为两个 APK 不能具有相同的应用 ID。

请注意，具有不同应用 ID 的 APK 在 Google Play 商店中会被视为不同的应用。所以如果您想要改用相同的应用详情分发多个 APK，每个 APK 以不同设备配置（如 API 级别）为目标，那么您必须对每个构建变体使用相同的应用 ID，但为每个 APK 提供不同的 `versionCode`。

> 注意：为了与以前的 SDK 工具兼容，如果您未在 build.gradle 文件中定义 applicationId 属性，构建工具会将 AndroidManifest.xml 文件中的软件包名称用作应用 ID。在这种情况下，重构您的软件包名称也会更改您的应用 ID。

提示：如果需要在清单文件中引用应用 ID，您可以在任何清单属性中使用 ${applicationId} 占位符。在构建期间，Gradle 会将此标记替换为实际的应用 ID。如需了解详情，请参阅[将构建变量注入清单]()。

## 更改用于测试的应用 ID

默认情况下，构建工具会将应用 ID 应用到您的[插桩测试]() APK，该 APK 将应用 ID 用于给定的构建变体，同时追加 .test。例如，`com.example.myapp.free` 构建变体的测试 APK 的应用 ID 为 `com.example.myapp.free.test`。

您可以通过在 `defaultConfig` 或 `productFlavor` 块中定义 `testApplicationId` 属性来更改应用 ID，不过应该没有必要这样做。

> 注意：为了避免与受测应用发生名称冲突，构建工具会为您的测试 APK 生成 R 类，其命名空间基于测试应用 ID，而不是清单文件中定义的软件包名称。

## 更改软件包名称

默认情况下，项目的软件包名称与应用 ID 匹配，但您可以更改软件包名称。不过，如果您要更改软件包名称，需要注意的是，软件包名称（由项目目录结构定义）应始终与 AndroidManifest.xml 文件中的 package 属性匹配，如下所示：

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.myapp"
    android:versionCode="1"
    android:versionName="1.0" >
```

Android 构建工具使用 package 属性来发挥两种作用：

* 它将此名称用作应用生成的 R.java 类的命名空间。
示例：对于上面的清单，R 类将为 com.example.myapp.R。

* 它会使用此名称解析清单文件中声明的任何相关类名。
示例：对于上面的清单，声明为 <activity android:name=".MainActivity"> 的 Activity 将解析为 com.example.myapp.MainActivity。

因此，`package` 属性中的名称应始终与项目的基础软件包名称匹配，基础软件包中保存着您的 Activity 及其他应用代码。当然，您的项目中可以包含子软件包，但是这些文件必须从 `package` 属性导入使用命名空间的 `R.java` 类，而且清单中声明的任何应用组件都必须添加缺失的子软件包名称（或者使用完全限定软件包名称）。

如果您要完全重构您的软件包名称，请确保也更新 `package` 属性。只要您使用 Android Studio 的工具重命名和重构您的软件包，那么这些属性就会自动保持同步。（如果它们未保持同步，您的应用代码将无法解析 R 类，因为它不再位于同一软件包中，并且清单无法识别您的 Activity 或其他组件。）

您必须始终在项目的主 `AndroidManifest.xml` 文件中指定 package 属性。如果您有其他清单文件（如产品变种或构建类型的清单文件），**请注意，优先级最高的清单文件提供的软件包名称始终用于最终合并的清单**。如需了解详情，请参阅[合并多个清单文件]()。

> 还有一点需要了解：尽管清单 `package` 和 `Gradle applicationId` 可以具有不同的名称，但构建工具会在构建结束时将应用 ID 复制到 APK 的最终清单文件中。所以，如果您在构建后检查 AndroidManifest.xml 文件，发现 package 属性发生更改就不足为奇了。实际上，Google Play 商店和 Android 平台会查看 package 属性来识别您的应用。所以，构建系统利用原始值（设置 R 类的命名空间并解析清单类名称）后，它会舍弃该值并将其替换为应用 ID。
