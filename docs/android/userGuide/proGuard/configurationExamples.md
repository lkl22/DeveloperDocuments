# Configuration - Examples

您可以在ProGuard发行版的 `examples` 目录中找到一些示例配置文件。

* [Processing different types of applications](#Processingdifferenttypesofapplications)
  * [A typical application](#Atypicalapplication)
  * [A typical applet](#Atypicalapplet)


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


