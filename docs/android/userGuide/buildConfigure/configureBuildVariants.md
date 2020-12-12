# 配置构建变体

构建变体是 Gradle 使用[一组特定规则]()将在构建类型和产品变种中配置的设置、代码和资源组合在一起所得到的结果。虽然您无法直接配置构建变体，但可以配置组成它们的构建类型和产品变种。

* [Configure build types](#Configurebuildtypes)
* [Configure product flavors](#Configureproductflavors)
  * [将多个产品变种与变种维度组合在一起](#将多个产品变种与变种维度组合在一起)
  * [过滤变体](#过滤变体)
* [创建源代码集](#创建源代码集)
  * [更改默认源代码集配置](#更改默认源代码集配置)
  * [使用源代码集构建](#使用源代码集构建)
* [声明依赖项](#声明依赖项)
* [配置签名设置](#配置签名设置)


## <a name="Configurebuildtypes">Configure build types</a>

您可以在模块级 `build.gradle` 文件中的 `android` 代码块内创建和配置构建类型。当您创建新模块时，Android Studio 会自动为您创建“debug”构建类型和“release”构建类型。虽然“debug”构建类型没有出现在构建配置文件中，但 Android Studio 会使用 `debuggable true` 配置它。这样，您就可以在安全的 Android 设备上调试应用，并使用常规调试密钥库配置 APK 签名。

如果您要添加或更改某些设置，可以将“debug”构建类型添加到配置中。以下示例为“debug”构建类型指定了 `applicationIdSuffix`，并配置了一个使用“debug”构建类型的设置进行初始化的“staging”构建类型。

```groovy
android {
    defaultConfig {
        manifestPlaceholders = [hostName:"www.example.com"]
        ...
    }
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }

        debug {
            applicationIdSuffix ".debug"
            debuggable true
        }

        /**
         * The `initWith` property allows you to copy configurations from other build types,
         * then configure only the settings you want to change. This one copies the debug build
         * type, and then changes the manifest placeholder and application ID.
         */
        staging {
            initWith debug
            manifestPlaceholders = [hostName:"internal.example.com"]
            applicationIdSuffix ".debugStaging"
        }
    }
}
```

> 注意：当您对构建配置文件做出更改时，Android Studio 会要求您将项目与新配置同步。如需同步项目，您可以点击做出更改后立即显示的通知栏中的 `Sync Now`，或点击工具栏中的 `Sync Project` 图标 。如果 Android Studio 发现配置有任何错误，就会显示 `Messages` 窗口，以说明相应的问题。

## <a name="Configureproductflavors">Configure product flavors</a>

创建产品变种与创建构建类型类似：将其添加到构建配置中的 `productFlavors` 代码块并添加所需的设置。产品变种支持与 `defaultConfig` 相同的属性，这是因为，`defaultConfig` 实际上属于 `ProductFlavor` 类。这意味着，您可以在 `defaultConfig` 代码块中提供所有变种的基本配置，每个变种均可更改其中任何默认值，如 `applicationId`。如需详细了解应用 ID，请参阅[设置应用 ID](./setApplicationId.md)。

> 注意：您仍然需要在 main/ 清单文件中使用 `package` 属性指定软件包名称。**此外，您还必须在源代码中使用该软件包名称引用 R 类，或解析任何相关的 Activity 或服务注册**。这样，您就可以使用 `applicationId` 为每个产品变种指定一个唯一的 ID，以用于打包和分发，而不必更改源代码。

**所有变种都必须属于一个指定的变种维度，即一个产品变种组**。您必须将所有变种分配给某个变种维度；否则，您将收到如下所示的构建错误。如果给定的模块仅指定一个变种维度，则 Android Gradle 插件会自动将该模块的所有变种分配给该维度。

```
Error:All flavors must now belong to a named flavor dimension.
  The flavor 'flavor_name' is not assigned to a flavor dimension.
```

> 提示：插件会尝试将应用的变体与本地库依赖项的变体进行匹配。由于[变体感知型依赖项匹配机制](https://developer.android.google.cn/studio/build/dependencies#variant_aware)依赖于您为变种维度命名的方式，因此您应`谨慎地为变种维度命名`。这样做可让您更好地控制来自本地依赖项的哪些代码和资源与应用的各个版本匹配。

以下代码示例创建了一个名为“version”的变种维度，并添加了“demo”和“full”产品变种。这些变种提供了它们自己的 `applicationIdSuffix` 和 `versionNameSuffix`：

```
android {
    ...
    defaultConfig {...}
    buildTypes {
        debug{...}
        release{...}
    }
    // Specifies one flavor dimension.
    flavorDimensions "version"
    productFlavors {
        demo {
            // Assigns this product flavor to the "version" flavor dimension.
            // If you are using only one dimension, this property is optional,
            // and the plugin automatically assigns all the module's flavors to
            // that dimension.
            dimension "version"
            applicationIdSuffix ".demo"
            versionNameSuffix "-demo"
        }
        full {
            dimension "version"
            applicationIdSuffix ".full"
            versionNameSuffix "-full"
        }
    }
}
```

> 注意：如需在 Google Play 中使用多 APK 支持分发应用，请将相同的 `applicationId` 值赋予所有变体，并为每个变体指定一个不同的 `versionCode`。如需在 Google Play 中以独立应用的形式分发应用的不同变体，您需要为每个变体分配一个不同的 `applicationId`。

创建并配置产品变种后，点击通知栏中的 `Sync Now`。同步完成后，Gradle 会根据构建类型和产品变种自动创建构建变体，并按照 `<product-flavor><Build-Type>` 为其命名。例如，如果您创建了“demo”和“full”产品变种，并保留了默认的“debug”和“release”构建类型，则 Gradle 会创建以下构建变体：

* demoDebug
* demoRelease
* fullDebug
* fullRelease

您可以将构建变体更改为您要构建并运行的任意变体，只需依次转到 `Build > Select Build Variant`，然后从下拉菜单中选择一个变体即可。不过，如需开始使用每个构建变体自己的功能和资源对其进行自定义，您需要知道如何[创建和管理源代码集]()。

### <a name="将多个产品变种与变种维度组合在一起">将多个产品变种与变种维度组合在一起</a> 

在某些情况下，您可能要将多个产品变种的配置组合在一起。例如，您可能要为基于 API 级别的“full”和“demo”产品变种创建不同的配置。为此，您可以使用 Android Plugin for Gradle 创建多组产品变种作为变种维度。在构建应用时，Gradle 会将您定义的每个变种维度中的产品变种配置以及构建类型配置组合在一起，以创建最终的构建变体。Gradle 不会将属于同一变种维度的产品变种组合在一起。

> 提示：如需根据 ABI 和屏幕密度为应用创建不同的版本，您应构建多个 APK，而不要使用产品变种。

以下代码示例使用 `flavorDimensions` 属性创建“mode”变种维度和“api”变种维度，前者用于对“full”和“demo”产品变种进行分组，后者用于根据 API 级别对产品变种配置进行分组：

```
android {
  ...
  buildTypes {
    debug {...}
    release {...}
  }

  // Specifies the flavor dimensions you want to use. The order in which you
  // list each dimension determines its priority, from highest to lowest,
  // when Gradle merges variant sources and configurations. You must assign
  // each product flavor you configure to one of the flavor dimensions.
  flavorDimensions "api", "mode"

  productFlavors {
    demo {
      // Assigns this product flavor to the "mode" flavor dimension.
      dimension "mode"
      ...
    }

    full {
      dimension "mode"
      ...
    }

    // Configurations in the "api" product flavors override those in "mode"
    // flavors and the defaultConfig block. Gradle determines the priority
    // between flavor dimensions based on the order in which they appear next
    // to the flavorDimensions property above--the first dimension has a higher
    // priority than the second, and so on.
    minApi24 {
      dimension "api"
      minSdkVersion 24
      // To ensure the target device receives the version of the app with
      // the highest compatible API level, assign version codes in increasing
      // value with API level. To learn more about assigning version codes to
      // support app updates and uploading to Google Play, read Multiple APK Support
      versionCode 30000 + android.defaultConfig.versionCode
      versionNameSuffix "-minApi24"
      ...
    }

    minApi23 {
      dimension "api"
      minSdkVersion 23
      versionCode 20000  + android.defaultConfig.versionCode
      versionNameSuffix "-minApi23"
      ...
    }

    minApi21 {
      dimension "api"
      minSdkVersion 21
      versionCode 10000  + android.defaultConfig.versionCode
      versionNameSuffix "-minApi21"
      ...
    }
  }
}
...
```

Gradle 创建的构建变体数量等于每个变种维度中的变种数量与您配置的构建类型数量的乘积。当 Gradle 为每个构建变体或对应的 APK 命名时，先显示属于较高优先级变种维度的产品变种，接着是较低优先级维度中的产品变种，再接着是构建类型。以上面的构建配置为例，Gradle 使用以下命名方案创建了总共 12 个构建变体：

* 构建变体：[minApi24, minApi23, minApi21][Demo, Full][Debug, Release]
* 对应的 APK：app-[minApi24, minApi23, minApi21]-[demo, full]-[debug, release].apk

**例如**，

* 构建变体：minApi24DemoDebug
* 对应的 APK：app-minApi24-demo-debug.apk

除了可以为各个产品变种和构建变体创建源代码集目录之外，您还可以为产品变种的每个组合创建源代码集目录。例如，您可以创建 Java 源代码并将其添加到 `src/demoMinApi24/java/` 目录中，只有在构建将这两个产品变种组合在一起的变体时，Gradle 才会使用这些源代码。**您为产品变种组合创建的源代码集的优先级高于属于各个产品变种的源代码集**。如需详细了解源代码集以及 Gradle 如何合并资源，请参阅关于如何创建源代码集的部分。

### <a name="过滤变体">过滤变体</a> 

Gradle 会为您配置的产品变种和构建类型的每种可能组合创建一个构建变体。不过，某些构建变体可能并不是您需要的，或者对于您的项目来说没有意义。您可以在模块级 `build.gradle` 文件中创建变体过滤器，以移除某些构建变体配置。

以上一部分中的构建配置为例，假设您打算让“demo”版应用仅支持 API 级别 23 及更高级别。您可以使用 `variantFilter` 代码块过滤掉所有将“minApi21”和“demo”产品变种组合在一起的构建变体配置：

```
android {
  ...
  buildTypes {...}

  flavorDimensions "api", "mode"
  productFlavors {
    demo {...}
    full {...}
    minApi24 {...}
    minApi23 {...}
    minApi21 {...}
  }

  variantFilter { variant ->
      def names = variant.flavors*.name
      // To check for a certain build type, use variant.buildType.name == "<buildType>"
      if (names.contains("minApi21") && names.contains("demo")) {
          // Gradle ignores any variants that satisfy the conditions above.
          setIgnore(true)
      }
  }
}
...
```

将变体过滤器添加到构建配置并点击通知栏中的 `Sync Now` 后，Gradle 会忽略符合您指定的条件的所有构建变体，并且当您从菜单栏中依次点击 `Build > Select Build Variant`（或点击工具窗口栏中的 `Build Variants` 图标 ）时，它们不会再显示在下拉菜单中。

## <a name="创建源代码集">创建源代码集</a>

默认情况下，Android Studio 会为您希望在所有构建变体之间共享的所有内容创建 `main/` [源代码集]()和目录。不过，您可以创建新的源代码集以精确控制 Gradle 为特定构建类型、产品变种（以及使用变种维度时的产品变种组合）和构建变体编译和打包的文件。例如，您可以在 `main/` 源代码集中定义基本功能，并使用产品变种源代码集为不同客户端更改应用的品牌信息，或仅为使用“debug”构建类型的构建变体添加特殊权限和日志记录功能。

Gradle 要求您以某种类似于 `main/` 源代码集的方式组织源代码集文件和目录。例如，Gradle 要求将“debug”构建类型特有的 Java 类文件放在 `src/debug/java/` 目录中。

Android Plugin for Gradle 提供了一项有用的 Gradle 任务，向您展示了如何组织每个构建类型、产品变种和构建变体的文件。例如，以下任务输出示例描述了 Gradle 要求在何处能够找到“debug”构建类型的某些文件：

```shell script
------------------------------------------------------------
Project :app
------------------------------------------------------------

...

debug
----
Compile configuration: compile
build.gradle name: android.sourceSets.debug
Java sources: [app/src/debug/java]
Manifest file: app/src/debug/AndroidManifest.xml
Android resources: [app/src/debug/res]
Assets: [app/src/debug/assets]
AIDL sources: [app/src/debug/aidl]
RenderScript sources: [app/src/debug/rs]
JNI sources: [app/src/debug/jni]
JNI libraries: [app/src/debug/jniLibs]
Java-style resources: [app/src/debug/resources]
```

如需查看此输出，请按以下步骤操作：

1. 点击 IDE 窗口右侧的 Gradle 图标 。
2. 依次转到 `MyApplication > Tasks > android`，然后双击 `sourceSets`。Gradle 执行该任务后，系统应该会打开 Run 窗口以显示输出。
3. 如果显示内容不是处于如上所示的文本模式，请点击 Run 窗口左侧的 Toggle view 图标 。

> 注意：任务输出还为您展示了如何组织要用于运行应用测试的文件的源代码集，如 test/ 和 androidTest/ 测试源代码集。

当您创建新的构建变体时，Android Studio 不会为您创建源代码集目录，而是为您提供一些有用的选项。例如，如需仅为“debug”构建类型创建 `java/` 目录，请执行以下操作：

1. 打开 Project 窗格，然后从窗格顶部的下拉菜单中选择 Project 视图。
2. 转到 `MyProject/app/src/`。
3. 右键点击 `src` 目录，然后依次选择 `New > Folder > Java Folder`。
4. 从 `Target Source Set` 旁边的下拉菜单中，选择 debug。
5. 点击 Finish。

Android Studio 会为“debug”构建类型创建源代码集目录，然后在其中创建 `java/` 目录。或者，您也可以让 Android Studio 在您为特定构建变体向项目中添加新文件时为您创建这些目录。例如，如需为“debug”构建类型创建值 `XML` 文件，请执行以下操作：

1. 在同一 Project 窗格中，右键点击 `src` 目录，然后依次选择 `New > XML > Values XML File`。
2. 输入 `XML` 文件的名称或保留默认名称。
3. 从 `Target Source Set` 旁边的下拉菜单中，选择 `debug`。
4. 点击 Finish。

由于“debug”构建类型被指定为目标源代码集，因此 Android Studio 会在创建 XML 文件时自动创建必要的目录。

### <a name="更改默认源代码集配置">更改默认源代码集配置</a>

如果您的源代码未按照 Gradle 要求的默认源代码集文件结构进行组织（如上文关于创建源代码集的部分中所述），您可以使用 `sourceSets` 代码块更改 Gradle 为源代码集的每个组件收集文件的位置。您无需改变文件的位置，只需向 Gradle 提供相对于模块级 `build.gradle` 文件的路径，Gradle 应该会在该路径下找到每个源代码集组件的文件。如需了解您可以配置哪些组件，以及是否可以将它们映射到多个文件或目录，请参阅 [Android Plugin for Gradle DSL 参考文档](https://google.github.io/android-gradle-dsl/current/com.android.build.gradle.api.AndroidSourceSet.html) 。

以下代码示例将 `app/other/` 目录中的源代码映射到了 `main` 源代码集的某些组件，并更改了 `androidTest` 源代码集的根目录。

```
android {
  ...
  sourceSets {
    // Encapsulates configurations for the main source set.
    main {
      // Changes the directory for Java sources. The default directory is
      // 'src/main/java'.
      java.srcDirs = ['other/java']

      // If you list multiple directories, Gradle uses all of them to collect
      // sources. Because Gradle gives these directories equal priority, if
      // you define the same resource in more than one directory, you get an
      // error when merging resources. The default directory is 'src/main/res'.
      res.srcDirs = ['other/res1', 'other/res2']

      // Note: You should avoid specifying a directory which is a parent to one
      // or more other directories you specify. For example, avoid the following:
      // res.srcDirs = ['other/res1', 'other/res1/layouts', 'other/res1/strings']
      // You should specify either only the root 'other/res1' directory, or only the
      // nested 'other/res1/layouts' and 'other/res1/strings' directories.

      // For each source set, you can specify only one Android manifest.
      // By default, Android Studio creates a manifest for your main source
      // set in the src/main/ directory.
      manifest.srcFile 'other/AndroidManifest.xml'
      ...
    }

    // Create additional blocks to configure other source sets.
    androidTest {

      // If all the files for a source set are located under a single root
      // directory, you can specify that directory using the setRoot property.
      // When gathering sources for the source set, Gradle looks only in locations
      // relative to the root directory you specify. For example, after applying the
      // configuration below for the androidTest source set, Gradle looks for Java
      // sources only in the src/tests/java/ directory.
      setRoot 'src/tests'
      ...
    }
  }
}
...
```

### <a name="使用源代码集构建">使用源代码集构建</a>

您可以让源代码集目录包含您希望只针对某些配置打包在一起的代码和资源。例如，如果您要构建“demoDebug”这个变体（“demo”产品变种和“debug”构建类型的混合产物），则 Gradle 会查看这些目录，并为它们指定以下优先级：

1. src/demoDebug/（构建变体源代码集）
2. src/debug/（构建类型源代码集）
3. src/demo/（产品变种源代码集）
4. src/main/（主源代码集）

> 注意：如果您将多个产品变种组合在一起，那么这些产品变种的优先级由它们所属的变种维度决定。使用 `android.flavorDimensions` 属性列出变种维度时，属于您`列出的第一个变种维度的产品变种的优先级高于属于第二个变种维度的产品变种`，依此类推。此外，`您为产品变种组合创建的源代码集的优先级高于属于各个产品变种的源代码集`。

上面列出的顺序决定了 Gradle 组合代码和资源时哪个源代码集的优先级更高。由于 `demoDebug/` 源代码集目录很可能包含该构建变体特有的文件，因此如果 `demoDebug/` 包含的某个文件在 `debug/` 中也进行了定义，Gradle 会使用 `demoDebug/` 源代码集中的文件。同样，Gradle 会为构建类型和产品变种源代码集中的文件指定比 `main/` 中的相同文件更高的优先级。在应用以下构建规则时，Gradle 会考虑这种优先级顺序：

* `java/` 目录中的所有源代码将一起编译以生成单个输出。
> 注意：对于给定的构建变体，如果 Gradle 遇到两个或更多个源代码集目录定义了同一个 Java 类的情况，就会抛出构建错误。例如，在构建调试 APK 时，您不能同时定义 `src/debug/Utility.java` 和 `src/main/Utility.java`。这是因为，Gradle 在构建过程中会查看这两个目录并`抛出“重复类”错误`。如果您希望不同的构建类型有不同版本的 Utility.java，则可以让每个构建类型定义各自的文件版本，而不是将其包含在 `main/` 源代码集中。

* 所有清单会合并成一个清单。将按照上面列表中的顺序指定优先级。也就是说，构建类型的清单设置会替换产品变种的清单设置，依此类推。如需了解详情，请参阅[清单合并](https://developer.android.google.cn/studio/build/manifest-merge)。
* 同样，`values/` 目录中的文件也会合并在一起。如果两个文件同名，例如存在两个 `strings.xml` 文件，将按照上面列表中的顺序指定优先级。也就是说，在构建类型源代码集的文件中定义的值会替换在产品变种的同一文件中定义的值，依此类推。
* `res/` 和 `asset/` 目录中的资源会打包在一起。如果在两个或更多个源代码集中定义了同名的资源，将按照上面列表中的顺序指定优先级。
* 最后，在构建 APK 时，`Gradle 会为库模块依赖项随附的资源和清单指定最低优先级`。

## <a name="声明依赖项">声明依赖项</a>

您可以为特定构建变体或测试源代码集配置依赖项，方法是在 `Implementation` 关键字前面加上`构建变体或测试源代码集`的名称作为前缀，如以下示例所示。

```
dependencies {
    // Adds the local "mylibrary" module as a dependency to the "free" flavor.
    freeImplementation project(":mylibrary")

    // Adds a remote binary dependency only for local tests.
    testImplementation 'junit:junit:4.12'

    // Adds a remote binary dependency only for the instrumented test APK.
    androidTestImplementation 'com.android.support.test.espresso:espresso-core:3.0.2'
}
```

如需了解详情，请参阅[添加构建依赖项](https://developer.android.google.cn/studio/build/dependencies)。

## <a name="配置签名设置">配置签名设置</a>

除非您明确定义发布 `build` 的签名配置，否则 Gradle 不会为该 build 的 APK 签名。您可以轻松创建发布密钥并使用 Android Studio 为“release”构建类型签名。

如需使用 Gradle 构建配置为“release”构建类型手动进行签名配置，请执行以下操作：

1. 创建一个密钥库。密钥库是一个包含一组私钥的二进制文件。您必须将密钥库保存在安全可靠的地方。
2. 创建一个私钥。私钥代表将通过应用识别的实体，如个人或公司。
3. 将签名配置添加到模块级 `build.gradle` 文件中：

```
...
android {
    ...
    defaultConfig {...}
    signingConfigs {
        release {
            storeFile file("myreleasekey.keystore")
            storePassword "password"
            keyAlias "MyReleaseKey"
            keyPassword "password"
        }
    }
    buildTypes {
        release {
            ...
            signingConfig signingConfigs.release
        }
    }
}
```

如需生成已签名的 APK，请从菜单栏中依次选择 `Build > Generate Signed APK`。`app/build/apk/app-release.apk` 中的软件包现已使用发布密钥进行签名。

> 注意：在构建文件中添加发布密钥和密钥库的密码并不是一种好的安全做法。作为替代方案，您可以将构建文件配置为从环境变量获取这些密码，或让构建流程提示您输入这些密码。

如需从环境变量获取这些密码，请添加以下代码：

```shell script
storePassword System.getenv("KSTOREPWD")
keyPassword System.getenv("KEYPWD")
```

如需让构建流程在您要从命令行调用 `build` 时提示您输入这些密码，请添加以下代码：

```shell script
storePassword System.console().readLine("\nKeystore password: ")
keyPassword System.console().readLine("\nKey password: ")
```

完成此流程后，您可以分发您的应用并在 Google Play 上发布它。

> 警告：请将密钥库和私钥保存在安全可靠的地方，并确保您为其创建了安全的备份。如果您将应用发布到 Google Play，随后丢失了为应用签名的密钥，那么您将无法发布任何应用更新，因为您必须始终使用相同的密钥为应用的所有版本签名。
