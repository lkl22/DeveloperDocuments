# Quick Start

有两种执行ProGuard的方法：

1. Standalone
2. 您的Gradle，Ant或Maven项目中的集成模式。

您也可以按照构建说明从源代码构建ProGuard。

## Standalone

首先，下载 [ProGuard版本](https://github.com/Guardsquare/proguard/releases) 或从 [源代码构建](https://www.guardsquare.com/manual/building?hsLang=en) ProGuard。 然后，可以通过在bin目录中找到一个脚本，从命令行直接执行ProGuard：


```
Linux/macOS
bin/proguard.sh -injars path/to/my-application.jar \
                -outjars path/to/obfuscated-application.jar \
                -libraryjars path/to/java/home/lib/rt.jar

Windows
bin\proguard.bat -injars path/to/my-application.jar ^
                 -outjars path/to/obfuscated-application.jar ^
                 -libraryjars path/to/java/home/lib/rt.jar
```

## Integrated

The ProGuard artifacts are hosted at [Maven Central](https://search.maven.org/search?q=g:com.guardsquare).

### Android Gradle project

在使用Android应用程序（apk，aab）或库（aar）时，可以将ProGuard包括在Gradle构建中，如下所示：

1. 通过在gradle.properties中禁用R8，可以直接使用ProGuard。

2. 或使用ProGuard的内置Gradle插件，您可以在build.gradle中应用它。

有关更多详细信息，请参阅 [Android Gradle](https://www.guardsquare.com/manual/setup/gradleplugin?hsLang=en)。

### Java or Kotlin Gradle project

您的 non-mobile Java或Kotlin应用程序可以执行ProGuard的Gradle任务：

```
task myProguardTask(type: proguard.gradle.ProGuardTask) {
.....
}
```

有关更多详细信息，请参见 [Java / Kotlin Gradle](https://www.guardsquare.com/manual/setup/gradle?hsLang=en)。

### Ant project

您还可以在您的Ant构建中包含ProGuard，您要做的就是将相关任务包含在build.xml文件中：

```
<taskdef resource="proguard/ant/task.properties"
        classpath="/usr/local/java/proguard/lib/proguard.jar" />
```

有关更多详细信息，请参见 [Ant](https://www.guardsquare.com/manual/setup/ant?hsLang=en)。

### Maven project

> **Warning**: 尽管我们并未正式提供Maven集成，也无法提供支持，但仍有可用的解决方案，但Guardsquare无法保证其提供的功能。

Some open-source implementations:

[https://github.com/wvengen/proguard-maven-plugin](https://github.com/wvengen/proguard-maven-plugin)

[https://github.com/dingxin/proguard-maven-plugin](https://github.com/dingxin/proguard-maven-plugin)
