# Configuration - Examples

您可以在ProGuard发行版的 `examples` 目录中找到一些示例配置文件。

* [Processing different types of applications](#Processingdifferenttypesofapplications)
  * [A typical application](#Atypicalapplication)
  * [A typical applet](#Atypicalapplet)
  * [A typical midlet](#Atypicalmidlet)
  * [A typical Java Card applet](#AtypicalJavaCardapplet)
  * [A typical xlet](#Atypicalxlet)
* [Processing common code constructs](#Processingcommoncodeconstructs)
  * [Processing native methods](#Processingnativemethods)


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


