# Configuration - Examples

您可以在ProGuard发行版的 `examples` 目录中找到一些示例配置文件。

* [Processing different types of applications](#Processingdifferenttypesofapplications)
  * [A typical application](#Atypicalapplication)
  * [A typical applet](#Atypicalapplet)
  * [A typical midlet](#Atypicalmidlet)
  * [A typical Java Card applet](#AtypicalJavaCardapplet)
  * [A typical xlet](#Atypicalxlet)
  * [A simple Android activity](#AsimpleAndroidactivity)
  * [A complete Android application](#AcompleteAndroidapplication)
  * [A typical library](#Atypicallibrary)
  * [All possible applications in the input jars](#Allpossibleapplicationsintheinputjars)
  * [All possible applets in the input jars](#Allpossibleappletsintheinputjars)
  * [All possible midlets in the input jars](#Allpossiblemidletsintheinputjars)
  * [All possible Java Card applets in the input jars](#AllpossibleJavaCardappletsintheinputjars)
  * [All possible xlets in the input jars](#Allpossiblexletsintheinputjars)
  * [All possible servlets in the input jars](#Allpossibleservletsintheinputjars)
  * [Scala applications with the Scala runtime](#ScalaapplicationswiththeScalaruntime)
* [Processing common code constructs](#Processingcommoncodeconstructs)
  * [Processing native methods](#Processingnativemethods)
  * [Processing callback methods](#Processingcallbackmethods)
  * [Processing enumeration classes](#Processingenumerationclasses)
  * [Processing serializable classes](#Processingserializableclasses)
  * [Processing bean classes](#Processingbeanclasses)
  * [Processing annotations](#Processingannotations)
  * [Processing database drivers](#Processingdatabasedrivers)
  * [Processing ComponentUI classes](#ProcessingComponentUIclasses)
* [Processing common libraries](#Processingcommonlibraries)
  * [Processing RMI code](#ProcessingRMIcode)
  * [Optimizing Gson code](#OptimizingGsoncode)
  * [Processing dependency injection](#Processingdependencyinjection)
  * [Processing Dagger code](#ProcessingDaggercode)


## <a name="Processingdifferenttypesofapplications">Processing different types of applications<a/>

### <a name="Atypicalapplication">A typical application<a/>

为了压缩，优化和混淆简单的Java应用程序，通常需要创建一个配置文件，例如 `myconfig.pro`，然后

> bin/proguard @myconfig.pro

配置文件指定应用程序的输入，输出和 entry points ：

```
-injars       myapplication.jar
-outjars      myapplication_out.jar
-libraryjars  <java.home>/jmods/java.base.jmod(!**.jar;!module-info.class)
-printmapping myapplication.map

-keep public class com.example.MyMain {
    public static void main(java.lang.String[]);
}
```

注意 `<java.home>` 系统属性的使用。 解析文件时，ProGuard会自动替换它。 在此示例中，库jar是基本Java运行时模块，减去了一些不需要的文件。 对于Java 8或更早版本，Java运行时jar将改为 `<java.home>/lib/rt.jar`。 如果您的应用程序依赖于它们，则可能需要其他模块或jar。

`-keep` 选项指定必须保留的应用程序的 entry points。 在这种情况下，实际上不需要访问修饰符 `public` 和 `static`，因为我们明确地知道指定的类和方法具有正确的访问标志。 这样看起来就更熟悉了。

> 请注意，所有类型名称均要完全指定：`com.example.MyMain` 和 `java.lang.String[]`。

我们正在使用 `-printmapping` 编写混淆处理映射文件，以便稍后对所有堆栈跟踪进行混淆处理，或者对扩展进行增量混淆处理。

我们可以通过其他一些选择来进一步改善结果：

```
-optimizationpasses 3
-overloadaggressively
-repackageclasses ''
-allowaccessmodification
```

这些选项不是必需的。 它们只是通过执行多达3次优化遍历，以及对类成员和包名进行混淆处理，从而从输出jar中节省了一些额外的字节。

通常，您可能需要一些其他选项来处理 native方法，回调方法，枚举，可序列化的类，Bean类，批注和资源文件。

### <a name="Atypicalapplet">A typical applet<a/>

这些选项可压缩，优化和混淆applet `com.example.MyApplet`：

```
-injars      in.jar
-outjars     out.jar
-libraryjars <java.home>/jmods/java.base.jmod(!**.jar;!module-info.class)

-keep public class com.example.MyApplet
```

典型的applet方法将自动保留，因为 `com.example.MyApplet` 是 `rt.jar` 库中Applet类的扩展。

如果适用，您应该添加用于处理 native方法，回调方法，枚举，可序列化类，Bean类，注释和资源文件的选项。

### <a name="Atypicalmidlet">A typical midlet<a/>

这些选项可压缩，优化，混淆和预验证Midlet `com.example.MyMIDlet`：

```ProGuard
-injars      in.jar
-outjars     out.jar
-libraryjars /usr/local/java/wtk2.5.2/lib/midpapi20.jar
-libraryjars /usr/local/java/wtk2.5.2/lib/cldcapi11.jar
-overloadaggressively
-repackageclasses ''
-allowaccessmodification
-microedition

-keep public class com.example.MyMIDlet
```

请注意，我们现在如何针对 `midpapi20.jar` 和 `cldcapi11.jar` 的**Java Micro Edition**运行时环境，而不是**Java Standard Edition**运行时环境 `rt.jar`。 您可以通过选择适当的jar来定位其他JME环境。

典型的 `midlet` 方法将自动保留，因为 `com.example.MyMIDlet` 是 `midpapi20.jar` 库中 `MIDlet` 类的扩展。

`-microedition `选项可确保类文件已针对 **Java Micro Edition** 进行了预验证，从而生成了紧凑的 `StackMap` 属性。 不再需要运行外部预验证器。

如果确实在不区分大小写的归档系统的平台（例如Windows）上使用外部预验证工具，请务必小心。 由于此工具将处理过的 jars 解压，因此您应该使用ProGuard的 `-dontusemixedcaseclassnames` 选项。

如果适用，您应该添加用于处理 native 方法和资源文件的选项。

> 注意，您仍然必须在相应的 `jad` 文件中调整 Midlet jar的大小。 ProGuard不会为您做到这一点。

### <a name="AtypicalJavaCardapplet">A typical Java Card applet<a/>

这些选项可压缩，优化和混淆 Java Card applet `com.example.MyApplet`：

```
-injars      in.jar
-outjars     out.jar
-libraryjars /usr/local/java/javacard2.2.2/lib/api.jar
-dontwarn    java.lang.Class
-overloadaggressively
-repackageclasses ''
-allowaccessmodification

-keep public class com.example.MyApplet
```

该配置与Midlet的配置非常相似，不同之处在于，该配置现在针对 **Java Card** 运行时环境。 这个环境没有 `java.lang.Class`，所以我们告诉ProGuard不要担心。

### <a name="Atypicalxlet">A typical xlet<a/>

这些选项可压缩，优化和混淆 xlet `com.example.MyXlet`：

```
-injars      in.jar
-outjars     out.jar
-libraryjars /usr/local/java/jtv1.1/javatv.jar
-libraryjars /usr/local/java/cdc1.1/lib/cdc.jar
-libraryjars /usr/local/java/cdc1.1/lib/btclasses.zip
-overloadaggressively
-repackageclasses ''
-allowaccessmodification

-keep public class com.example.MyXlet
```

该配置与Midlet的配置非常相似，不同之处在于，该配置现在使用 `Java TV API` 面向 `CDC` 运行时环境。

### <a name="AsimpleAndroidactivity">A simple Android activity<a/>

这些选项可压缩，优化和混淆单个Android activity `com.example.MyActivity`：

```
-injars      bin/classes
-outjars     bin/classes-processed.jar
-libraryjars /usr/local/java/android-sdk/platforms/android-9/android.jar

-android
-dontpreverify
-repackageclasses ''
-allowaccessmodification
-optimizations !code/simplification/arithmetic

-keep public class com.example.MyActivity
```

我们以Android运行时为目标，并将activity作为 entry point。

预验证与 dex编译器和 Dalvik VM 无关，因此我们可以使用 `-dontpreverify` 选项将其关闭。

`-optimizations` 选项禁用 Dalvik 1.0 和 1.5 无法处理的一些算术简化。 请注意，Dalvik VM 也无法处理（静态字段）过度的过载。

如果适用，您应该添加用于处理 native方法，回调方法，枚举，注解和资源文件的选项。

### <a name="AcompleteAndroidapplication">A complete Android application<a/>

> Android SDK（带有Ant，Gradle，Android Studio和Eclipse）的标准构建过程已经将ProGuard与所有正确的设置集成在一起。 您只需要通过取消注释Ant项目的文件project.properties中的“ proguard.config = .....”行或修改Gradle项目的build.gradle文件来启用ProGuard。 然后，您不需要以下任何配置。

Notes:

* 如果出现问题，您可能需要检查此行上列出的配置文件（proguard-project.txt，...）是否包含应用程序所需的设置。
* Android SDK版本20及更高版本具有用于启用优化的其他配置文件：`${sdk.dir}/tools/proguard/proguard-android-optimize.txt`，而不是默认的 `${sdk.dir}/tools/proguard/proguard- android.txt`。
* 构建过程已经在为您设置必要的程序jar，库jar和输出jar –不再指定它们。
* 如果您收到有关缺少引用的类的警告：库引用缺少的类是很常见的。 请参阅“疑难解答”部分中的“警告：找不到引用的类”。

有关更多信息，您可以查阅Android SDK中的官方[开发人员指南](http://developer.android.com/guide/developing/tools/proguard.html)。

如果您是从头开始构建构建过程：这些选项将压缩，优化和混淆编译类和外部库中的所有公共`activities`, `services`, `broadcast receivers`, and `content providers`：

```
-injars      bin/classes
-injars      bin/resources.ap_
-injars      libs
-outjars     bin/application.apk
-libraryjars /usr/local/android-sdk/platforms/android-28/android.jar

-android
-dontpreverify
-repackageclasses ''
-allowaccessmodification
-optimizations !code/simplification/arithmetic
-keepattributes *Annotation*

-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

-keep public class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(...);
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

-keepclassmembers class * extends android.content.Context {
    public void *(android.view.View);
    public void *(android.view.MenuItem);
}

-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}

-keepclassmembers class **.R$* {
    public static <fields>;
}

-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
```

最重要的是，我们保留了应用程序的 `AndroidManifest.xml` 文件可能引用的所有基本类。 **如果清单文件包含其他类和方法，则可能还必须指定这些类和方法**。

我们保留注解，因为它们可能被自定义RemoteView和各种框架使用。

我们将使用典型的构造函数保留所有自定义View扩展和其他类，因为它们可能是从XML布局文件引用的。

我们还将在自定义 `context` 扩展中保留 `onClick` 处理程序，因为它们可能是从XML布局文件引用的。

我们还将所需的静态字段保留在Parcelable实现中，因为可以通过自省访问它们。

我们保留自动生成的R类的引用内部类的静态字段，以防万一您的代码通过自省访问这些字段。 请注意，编译器已经内联了原始字段，因此ProGuard通常可以完全删除所有这些类（因为未引用这些类，因此它们不是必需的）。

最后，我们保留带注解的 `Javascript` 接口方法，以便可以使用其原始名称导出和访问它们。 尚未注解的 `Javascript` 接口方法（在针对4.2之前的Android版本的代码中）仍需要手动保留。

如果您使用其他Google API，则还必须指定这些API，例如：

```
-libraryjars /usr/local/java/android-sdk/extras/android/support/v4/android-support-v4.jar
-libraryjars /usr/local/java/android-sdk/add-ons/addon-google_apis-google-21/libs/maps.jar
```

如果您使用的是Google的可选许可证验证库，则可以将其代码与自己的代码混淆。 您必须保留其 `ILicensingService` 接口才能使该库正常工作：

```
-keep public interface com.android.vending.licensing.ILicensingService
```

如果您使用的是Android兼容性库，则应添加以下行，以使ProGuard知道该库引用了所有API版本中均不可用的某些类是可以的：

```
-dontwarn android.support.**
```

如果适用，您应该添加用于处理 native方法，回调方法，枚举和资源文件的选项。 您可能还需要添加选项以生成有用的堆栈跟踪并删除日志记录。 您可以在ProGuard发行版的 `examples/standalone/android.pro` 中找到完整的示例配置。

### <a name="Atypicallibrary">A typical library<a/>

这些选项可压缩，优化和混淆整个库，从而保留所有公共和受保护的类以及类成员，native 方法名称和序列化代码。 然后，该库的已处理版本仍可照原样使用，以基于其公共API开发代码。

```proGuard
-injars       in.jar
-outjars      out.jar
-libraryjars  <java.home>/jmods/java.base.jmod(!**.jar;!module-info.class)
-printmapping out.map

-keep public class * {
    public protected *;
}

-keepparameternames
-renamesourcefileattribute SourceFile
-keepattributes Signature,Exceptions,*Annotation*,
                InnerClasses,PermittedSubclasses,EnclosingMethod,
                Deprecated,SourceFile,LineNumberTable

-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}

-keepclassmembers,allowoptimization enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
```

此配置应保留开发人员曾经想在库中访问的所有内容。 仅当动态调用了其他任何非公共类或方法时，才应使用附加的 `-keep` 选项来指定它们。

* 必须具有“`Signature`”属性才能访问通用类型。
* 必须保留“`Exceptions`”属性，以便编译器知道哪些异常方法可能抛出。
* 各种“`*Annotations*`”属性包含任何注解，开发人员可能需要通过反射来访问它们。
* 对于可以从库外部引用的任何内部类，也必须保留“`InnerClasses`”属性（或更确切地说，其源名称部分）。 否则，javac 编译器将无法找到内部类。
* “`PermittedSubclasses`”属性定义了密封的类，开发人员无法进一步扩展。
* “`EnclosingMethod`”属性标记在方法内部定义的类。
* “`Deprecated`”属性标记了任何不推荐使用的类，字段或方法，这可能对开发人员很有用。
* `-keepparameternames` 选项将参数名称保留在公共库方法的 “`LocalVariableTable`” 和 “`LocalVariableTypeTable`” 属性中。 某些IDE可以将这些名称提供给使用该库的开发人员。
* 最后，我们保留“Deprecated”属性和用于生成有用的堆栈跟踪的属性。

我们还添加了一些用于处理 native方法，枚举，可序列化的类和注解的选项，所有这些选项均在各自的示例中进行了讨论。

### <a name="Allpossibleapplicationsintheinputjars">All possible applications in the input jars<a/>

这些选项可压缩，优化和混淆 `in.jar` 中的所有公共应用程序：

```
-injars      in.jar
-outjars     out.jar
-libraryjars <java.home>/jmods/java.base.jmod(!**.jar;!module-info.class)
-printseeds

-keepclasseswithmembers public class * {
    public static void main(java.lang.String[]);
}
```

注意使用 `-keepclasseswithmembers`。 我们不想保留所有类，仅保留具有 `main` 方法的所有类，以及那些方法。

`-printseeds` 选项打印出将确切保留哪些类，因此我们确定知道将得到想要的东西。

如果适用，您应该添加用于处理 native方法，回调方法，枚举，可序列化类，Bean类，注解和资源文件的选项。

### <a name="Allpossibleappletsintheinputjars">All possible applets in the input jars<a/>

这些选项可压缩，优化和混淆 `in.jar` 中的所有公共小程序：

```
-injars      in.jar
-outjars     out.jar
-libraryjars <java.home>/jmods/java.base.jmod(!**.jar;!module-info.class)
-libraryjars <java.home>/jmods/java.desktop.jmod(!**.jar;!module-info.class)
-printseeds

-keep public class * extends java.applet.Applet
```

我们只是保留所有扩展 `Applet` 类的类。

同样，`-printseeds` 选项打印出将保留哪些小程序。

如果适用，您应该添加用于处理 native方法，回调方法，枚举，可序列化类，Bean类，注解和资源文件的选项。

### <a name="Allpossiblemidletsintheinputjars">All possible midlets in the input jars<a/>

这些选项可压缩，优化，混淆和预验证 `in.jar` 中的所有公共 `Midlet`：

```
-injars      in.jar
-outjars     out.jar
-libraryjars /usr/local/java/wtk2.5.2/lib/midpapi20.jar
-libraryjars /usr/local/java/wtk2.5.2/lib/cldcapi11.jar
-overloadaggressively
-repackageclasses ''
-allowaccessmodification
-microedition
-printseeds

-keep public class * extends javax.microedition.midlet.MIDlet
```

我们只是保留所有扩展 `MIDlet` 类的类。

`-microedition` 选项可确保类文件已针对 Java Micro Edition 进行了预验证，从而生成了紧凑的 `StackMap` 属性。 不再需要运行外部预验证器。

如果确实在不区分大小写的归档系统的平台（例如Windows）上使用外部预验证工具，请务必小心。 由于此工具将处理过的 jars 解包，因此您应该使用ProGuard的 `-dontusemixedcaseclassnames` 选项。

`-printseeds` 选项打印出将保留哪些 midlet。

如果适用，您应该添加用于处理 native方法和资源文件的选项。

> 注意，您仍然必须在相应的 jad 文件中调整 `Midlet jar` 的大小。 ProGuard不会为您做到这一点。 

### <a name="AllpossibleJavaCardappletsintheinputjars">All possible Java Card applets in the input jars<a/>

这些选项可压缩，优化和混淆 `in.jar` 中的所有公共 `Java Card` 小程序：

```
-injars      in.jar
-outjars     out.jar
-libraryjars /usr/local/java/javacard2.2.2/lib/api.jar
-dontwarn    java.lang.Class
-overloadaggressively
-repackageclasses ''
-allowaccessmodification
-printseeds

-keep public class * implements javacard.framework.Applet
```

我们只是保留所有实现 `Applet` 接口的类。

`-printseeds` 选项打印出将保留哪些小程序。

### <a name="Allpossiblexletsintheinputjars">All possible xlets in the input jars<a/>

这些选项可压缩，优化和混淆 `in.jar` 中的所有公共 `xlet`：

```
-injars      in.jar
-outjars     out.jar
-libraryjars /usr/local/java/jtv1.1/javatv.jar
-libraryjars /usr/local/java/cdc1.1/lib/cdc.jar
-libraryjars /usr/local/java/cdc1.1/lib/btclasses.zip
-overloadaggressively
-repackageclasses ''
-allowaccessmodification
-printseeds

-keep public class * implements javax.tv.xlet.Xlet
```

我们只是保留所有实现 `Xlet` 接口的类。

`-printseeds` 选项打印出将保留哪些 `xlet`。

### <a name="Allpossibleservletsintheinputjars">All possible servlets in the input jars<a/>

这些选项可压缩，优化和混淆 `in.jar` 中的所有公共 `servlet`：

```
-injars      in.jar
-outjars     out.jar
-libraryjars <java.home>/lib/rt.jar
-libraryjars /usr/local/java/servlet/servlet.jar
-printseeds

-keep public class * implements javax.servlet.Servlet
```

保留所有 `servlet` 与保留所有小程序非常相似。 `Servlet API`不是标准运行时jar的一部分，因此我们将其指定为库。 不要忘记使用正确的路径名。

然后，我们保留所有实现Servlet接口的类。 我们之所以使用Implements关键字，是因为在这种情况下它看起来更加熟悉，但是就ProGuard而言，它等效于extends。

`-printseeds` 选项打印出将确切保留哪些 `servlet`。

如果适用，您应该添加用于处理 native方法，回调方法，枚举，可序列化类，Bean类，注解和资源文件的选项。

### <a name="ScalaapplicationswiththeScalaruntime">Scala applications with the Scala runtime<a/>

这些选项可压缩，优化和混淆 `in.jar` 中的所有公共 `Scala` 应用程序：

```
-injars      in.jar
-injars      /usr/local/java/scala-2.9.1/lib/scala-library.jar
-outjars     out.jar
-libraryjars <java.home>/jmods/java.base.jmod(!**.jar;!module-info.class)

-dontwarn scala.**

-keepclasseswithmembers public class * {
    public static void main(java.lang.String[]);
}

-keep class * implements org.xml.sax.EntityResolver

-keepclassmembers class * {
    ** MODULE$;
}

-keepclassmembernames class scala.concurrent.forkjoin.ForkJoinPool {
    long eventCount;
    int  workerCounts;
    int  runControl;
    scala.concurrent.forkjoin.ForkJoinPool$WaitQueueNode syncStack;
    scala.concurrent.forkjoin.ForkJoinPool$WaitQueueNode spareStack;
}

-keepclassmembernames class scala.concurrent.forkjoin.ForkJoinWorkerThread {
    int base;
    int sp;
    int runState;
}

-keepclassmembernames class scala.concurrent.forkjoin.ForkJoinTask {
    int status;
}

-keepclassmembernames class scala.concurrent.forkjoin.LinkedTransferQueue {
    scala.concurrent.forkjoin.LinkedTransferQueue$PaddedAtomicReference head;
    scala.concurrent.forkjoin.LinkedTransferQueue$PaddedAtomicReference tail;
    scala.concurrent.forkjoin.LinkedTransferQueue$PaddedAtomicReference cleanMe;
}
```

该配置与处理应用程序基本相同，因为Scala被编译为普通的Java字节码。 但是，该示例也会处理Scala运行时库。 处理过的jar可以比原始代码小一个数量级，并且快几倍（例如，对于Scala代码示例）。

`-dontwarn` 选项告诉ProGuard不要抱怨Scala运行时中的某些伪像，它是由scalac编译器编译的方式（至少在Scala 2.9.1和更早的版本中）。 请注意，应始终谨慎使用此选项。

附加的 `-keep` 选项可确保不删除或重命名通过自省访问的某些类和某些字段。

如果适用，您应该添加用于处理 native方法，回调方法，枚举，可序列化类，Bean类，注解和资源文件的选项。

## <a name="Processingcommoncodeconstructs">Processing common code constructs<a/>

### <a name="Processingnativemethods">Processing native methods<a/>

如果您的应用程序，小程序，servlet，库等包含 `native` 方法，则需要保留它们的名称和类的名称，以便它们仍可以链接到 native 库。 以下附加选项将确保：

```
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}
```

注意使用 `-keepclasseswithmembernames`。 我们不想保留所有类或所有native方法。 我们只是想避免混淆相关名称。 修饰符 `includeescriptorclasses` 还可以确保返回类型和参数类型也不会重命名，因此整个签名仍与 native 库兼容。

ProGuard不会查看您的 native 代码，因此不会自动保留 native 代码调用的类或类成员。 这些是entry points，您必须明确指定这些entry points。 

### <a name="Processingcallbackmethods">Processing callback methods<a/>

如果您的应用程序，小程序，servlet，库等包含从外部代码（native代码，脚本等）调用的回调方法，则您将需要保留它们，并且可能还保留它们的类。 它们只是代码的entry points，就像应用程序的 main 方法一样。 如果其他 `-keep` 选项未保留它们，则类似以下选项的内容将保留回调类和方法：

```
-keep class com.example.MyCallbackClass {
    void myCallbackMethod(java.lang.String);
}
```

**这样可以防止给定的类和方法被删除或重命名**。

### <a name="Processingenumerationclasses">Processing enumeration classes<a/>

如果您的应用程序，小程序，servlet，库等包含枚举类，则必须保留一些特殊方法。 Java 5中引入了枚举。java编译器将枚举转换为具有特殊结构的类。 值得注意的是，这些类包含一些静态方法的实现，运行时环境可以通过自省访问。 您必须明确指定这些内容，以确保它们不会被删除或混淆：

```
-keepclassmembers,allowoptimization enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
```

### <a name="Processingserializableclasses">Processing serializable classes<a/>

更复杂的应用程序，小程序，Servlet，libraries等可能包含序列化的类。 根据使用方式的不同，可能需要特别注意：

通常，序列化只是传输数据的一种手段，而无需长期存储。 压缩和混淆的类随后应继续正常运行，并具有以下附加选项：

```
    -keepclassmembers class * implements java.io.Serializable {
        private static final java.io.ObjectStreamField[] serialPersistentFields;
        private void writeObject(java.io.ObjectOutputStream);
        private void readObject(java.io.ObjectInputStream);
        java.lang.Object writeReplace();
        java.lang.Object readResolve();
    }
```

`-keepclassmembers` 选项可确保保留任何序列化方法。 通过使用此选项而不是基本的 `-keep` 选项，我们不会强制保留所有可序列化的类，而只是保留了实际使用的类的成员列表。

有时，存储序列化的数据，然后在以后将其读回到可序列化类的更新版本中。 然后，必须注意这些类与它们的未处理版本和将来的处理版本保持兼容。 在这种情况下，相关类很可能具有 `serialVersionUID` 字段。 然后，以下选项应足以确保随时间推移的兼容性：

```
    -keepnames class * implements java.io.Serializable

    -keepclassmembers class * implements java.io.Serializable {
        static final long serialVersionUID;
        private static final java.io.ObjectStreamField[] serialPersistentFields;
        !static !transient <fields>;
        private void writeObject(java.io.ObjectOutputStream);
        private void readObject(java.io.ObjectInputStream);
        java.lang.Object writeReplace();
        java.lang.Object readResolve();
    }
```

`serialVersionUID` 和 `serialPersistentFields` 行可确保保留这些字段（如果存在）。 `<fields>` 行保留所有非静态，非瞬态字段及其原始名称。 然后，对序列化过程和反序列化过程的内省将找到一致的名称。

有时，序列化的数据必须保持兼容，但是所涉及的类缺少 `serialVersionUID` 字段。 我想象原始代码将很难维护，因为串行版本UID是根据可序列化类的功能列表计算出来的。 稍微更改类可能会更改计算的串行版本UID。 功能列表在Sun的Java对象序列化规范的流唯一标识符部分中指定。 以下指令至少应部分确保与原始类的兼容性：

```
    -keepnames class * implements java.io.Serializable

    -keepclassmembers class * implements java.io.Serializable {
        static final long serialVersionUID;
        private static final java.io.ObjectStreamField[] serialPersistentFields;
        !static !transient <fields>;
        !private <fields>;
        !private <methods>;
        private void writeObject(java.io.ObjectOutputStream);
        private void readObject(java.io.ObjectInputStream);
        java.lang.Object writeReplace();
        java.lang.Object readResolve();
    }
```

新选项强制保留UID计算中涉及的元素。 另外，用户将必须手动指定可序列化类的所有接口（使用诸如“`-keep interface MyInterface`”之类的东西），因为在计算UID时也会使用这些名称。 一种快速但次优的选择是将所有接口都保留为 “`-keep interface *`”。

在极少数情况下，您要在Java 8或更高版本中序列化lambda表达式，您需要保留一些方法并改编出现它们的类的硬编码名称：

```
    -keepclassmembers class * {
        private static synthetic java.lang.Object $deserializeLambda$(java.lang.invoke.SerializedLambda);
    }

    -keepclassmembernames class * {
        private static synthetic *** lambda$*(...);
    }

    -adaptclassstrings com.example.Test
```

这应该满足Java运行时反序列化代码中的反射。

请注意，以上选项可能会保留比严格必要更多的类和类成员。 例如，大量的类可以实现 `Serialization` 接口，但是实际上只有少数可以被序列化。 了解您的应用程序并调整配置通常会产生更紧凑的结果。

### <a name="Processingbeanclasses">Processing bean classes<a/>

如果您的应用程序，小程序，servlet，库等广泛使用bean类的自省功能来查找bean编辑器类或getter和setter方法，则配置可能会很麻烦。 除了确保Bean类名或getter和setter名称不变之外，您无能为力。 例如：

```
-keep public class com.example.MyBean {
    public void setMyProperty(int);
    public int getMyProperty();
}

-keep public class com.example.MyBeanEditor
```

如果要显式列出的元素太多，则类名和方法签名中的通配符可能会有所帮助。 此示例在包 `mybeans` 的类中保留所有可能的setter和getter：

```
-keep class mybeans.** {
    void set*(***);
    void set*(int, ***);

    boolean is*();
    boolean is*(int);

    *** get*();
    *** get*(int);
}
```

`***`通配符匹配任何类型（primitive or non-primitive, array or non-array）。 具有'int'参数的方法与作为列表的属性匹配。

### <a name="Processingannotations">Processing annotations<a/>

如果您的应用程序，小程序，Servlet，库等使用注解，则可能需要将其保留在处理后的输出中。 注解由对代码的执行没有直接影响的属性表示。 但是，可以通过自省来检索其值，从而使开发人员可以相应地调整执行行为。 默认情况下，ProGuard将注解属性视为可选属性，并在混淆步骤中将其删除。 如果需要它们，则必须明确指定：

```
-keepattributes *Annotation*
```

为简便起见，我们指定一个通配符属性名称，该名称将与 `RuntimeVisibleAnnotations`，`RuntimeInvisibleAnnotations`，`RuntimeVisibleParameterAnnotations`，`RuntimeInvisibleParameterAnnotations` 和 `AnnotationDefault` 匹配。 根据所处理代码的目的，您可以优化此选择，例如不保留运行时不可见的注解（仅在编译时使用）。

某些代码可能会进一步使用自省来找出匿名内部类的封装方法。 在这种情况下，还必须保留相应的属性：

```
-keepattributes EnclosingMethod
```

### <a name="Processingdatabasedrivers">Processing database drivers<a/>

数据库驱动程序是驱动程序接口的实现。 由于它们通常是动态创建的，因此您可能希望保留要作为 entry points 处理的所有实现：

```
-keep class * implements java.sql.Driver
```

如果要在代码中实例化驱动程序（不必自己实现任何驱动程序），则此选项还可以消除ProGuard打印出有关 `（java.sql.Driver）Class.forName` 构造的注解。

### <a name="ProcessingComponentUIclasses">Processing ComponentUI classes<a/>

Swing UI的外观被实现为 `ComponentUI` 类的扩展。 由于某种原因，它们必须包含一个静态方法 `createUI`，`Swing API`使用自省功能调用该方法。 因此，您应始终将方法保留为 entry point，例如：

```
-keep class * extends javax.swing.plaf.ComponentUI {
    public static javax.swing.plaf.ComponentUI createUI(javax.swing.JComponent);
}
```

此选项还保留类本身。

## <a name="Processingcommonlibraries">Processing common libraries<a/>

### <a name="ProcessingRMIcode">Processing RMI code<a/>

据报道，处理RMI代码最简单的方法是先使用ProGuard处理代码，然后调用 `rmic` 工具。 如果无法做到这一点，您可能想尝试以下方法：

```
-keepattributes Exceptions

-keep interface * extends java.rmi.Remote {
    <methods>;
}

-keep class * implements java.rmi.Remote {
    <init>(java.rmi.activation.ActivationID, java.rmi.MarshalledObject); {: #activation}
}
```

第一个 `-keep` 选项保留所有的 Remote 接口及其方法。 第二个保留所有实现以及它们的特定RMI构造函数（如果有）。

还必须保留 `Exceptions` 属性，因为RMI处理代码会进行自省以检查方法签名是否兼容。

### <a name="OptimizingGsoncode">Optimizing Gson code<a/>

ProGuard通过检测使用 `Gson` 库序列化了哪些 `domain` 类，然后通过更有效的硬编码序列化来替代基于反射的实现，来优化Gson代码。

GSON优化默认情况下处于启用状态，不需要任何其他配置。 如果您禁用了优化，则GSON库仍然依赖于对其序列化的类的字段的反射。 然后，您需要保留无参数构造函数和序列化字段，以免对其进行删除，优化或混淆。 例如：

```
-keepclassmembers class com.example.SerializedClass {
    <fields>;
    <init>();
}
```

创建配置时，可以指定选项 `-addconfigurationdebugging`，以在运行时获取有关必要设置的反馈。

另外，您可以确保使用 `@SerializedName` 显式注解字段，以便可以混淆字段名称。 然后，您可以使用以下命令同时保留所有这些对象：

```
-keepclasseswithmembers,allowobfuscation,includedescriptorclasses class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

-keepclassmembers enum * {
    @com.google.gson.annotations.SerializedName <fields>;
}
```

### <a name="Processingdependencyinjection">Processing dependency injection<a/>

如果您的应用程序使用JEE样式的依赖项注入，则应用程序容器将自动将资源类的实例分配给使用@Resource注解的字段和方法。 容器会进行内省，甚至直接访问私有类成员。 它通常根据类型名称和类成员名称来构造资源名称。 然后，我们必须避免删除或重命名此类类成员：

```
-keepclassmembers class * {
    @javax.annotation.Resource *;
}
```

Spring框架还有另一个类似的注解 `@Autowired`：

```
-keepclassmembers class * {
    @org.springframework.beans.factory.annotation.Autowired *;
}
```

### <a name="ProcessingDaggercode">Processing Dagger code<a/>

您的Android应用程序可能正在使用Dagger库进行依赖项注入。

`Dagger 1` 严重依赖反射，因此您可能需要一些其他配置以确保其继续运行。 DexGuard的默认配置已经保留了一些必需的类：

```
-keepclassmembers,allowobfuscation class * {
    @dagger.** *;
}

-keep class **$$ModuleAdapter
-keep class **$$InjectAdapter
-keep class **$$StaticInjection

-if   class **$$ModuleAdapter
-keep class <1>

-if   class **$$InjectAdapter
-keep class <1>

-if   class **$$StaticInjection
-keep class <1>

-keepnames class dagger.Lazy
```

这样，Dagger可以根据名称对组合相应的类对。

此外，如果您的代码通过 `@Module(injects = { SomeClass.class }, ...)` 之类的注释将依赖项注入某些给定的类中，则还需要保留指定的名称：

```
-keep class com.example.SomeClass
```

Dagger2 不再依赖反射。 您不需要在那里保留任何类。


