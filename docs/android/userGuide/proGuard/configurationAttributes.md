# Configuration - Attributes

类文件本质上定义了类，它们的字段及其方法。 许多必需和非必需数据作为属性附加到这些类，字段和方法。 例如，属性可以包含字节码，源文件名，行号表等。

ProGuard的混淆步骤会删除执行代码通常不需要的属性。 使用 `-keepattributes` 选项，可以为要保留的属性指定过滤器，例如，如果代码通过反射访问它们，或者要保留一些编译或调试信息。 过滤器的工作方式与ProGuard中的任何过滤器一样。

支持以下通配符：

通配符（WILDCARD） |	含义（MEANING）
---|---
? | 匹配属性名称中的任何单个字符。
\* | 与属性名称的任何部分匹配。

带有感叹号 “!” 的属性名称 在进一步尝试与过滤器中后续属性名称匹配时被排除在外。 确保正确指定过滤器，因为不会检查它们是否存在潜在的错别字。

例如，以下设置保留了一些可选属性，这些可选属性在处理打算用作库的代码时通常是必需的：

```
-keepattributes Exceptions,InnerClasses,Signature,Deprecated,
                SourceFile,LineNumberTable,*Annotation*,EnclosingMethod
```

Java字节码规范当前指定以下属性列表。

## Optional attributes

ProGuard的混淆步骤默认会丢弃以下可选属性。 您可以使用 `-keepattributes` 选项保留它们。

Attribute | Desc
---|---
SourceFile | 指定从编译类文件中的源文件的名称。<br/><br/>如果存在，则在堆栈跟踪中报告该名称。
SourceDir<br/>(J++ extension) | 指定从编译类文件中的源目录的名称。
Record<br/>(Java 14 or higher) | 指定记录类的组件。 代码可以通过反射访问此信息。
InnerClasses | 指定一个类及其内部类和外部类之间的关系。<br/><br/>除此以外，在内部类和外部类的名称之间使用 `“\$”` 分隔符的命名约定之外，内部类与普通类一样。<br/><br/>编译器可能需要此信息才能找到已编译库中引用的类。 代码可以通过反射来访问此信息，例如，以派生该类的简单名称。
PermittedSubclasses<br/>(Java 15 or higher) | 指定密封的类或接口的允许扩展或实现。
EnclosingMethod<br/>(Java 5 or higher) | 指定定义类的方法。 <br/><br/>编译器可能需要此信息才能找到已编译库中引用的类。 <br/><br/>代码可以通过反射来访问此信息，例如，以派生该类的简单名称。
Deprecated | 指示已弃用该类，字段或方法。
Synthetic | 指示类，字段或方法是由编译器生成的。
Signature<br/>(Java 5 or higher) | 指定类，字段或方法的通用签名。 <br/><br/>编译器可能需要此信息来正确地编译使用已编译库中泛型类型的类。 <br/><br/>代码可以通过反射访问此签名。
MethodParameters<br/>(Java 8 or higher) | 指定**方法的参数的名称和访问标志**。 代码可以通过反射访问此信息。
Exceptions | 指定**方法可能引发的异常**。 编译器可以使用此信息来强制捕获它们。
LineNumberTable | 指定**方法的行号**。 如果存在，这些行号将在堆栈跟踪中报告。
LocalVariableTable | 指定**方法的局部变量的名称和类型**。 <br/><br/>如果存在，则某些IDE可能会使用此信息来帮助自动补全。
LocalVariableTypeTable<br/>(Java 5 or higher) | 指定**方法的局部变量的名称和通用类型**。 <br/><br/>如果存在，则某些IDE可能会使用此信息来帮助自动补全。
RuntimeVisibleAnnotations<br/>(Java 5 or higher) | **为类，字段和方法指定在运行时可见的注解**。 <br/><br/>编译器和注解处理器可以使用这些注解。 代码可以通过反射来访问它们。
RuntimeInvisibleAnnotations<br/>(Java 5 or higher) | **指定在编译时对于类，字段和方法可见的注解**。 <br/><br/>编译器和注解处理器可以使用这些注解。
RuntimeVisibleParameterAnnotations<br/>(Java 5 or higher) | **指定在运行时对于方法参数可见的注解**。 <br/><br/>编译器和注解处理器可以使用这些注解。 代码可以通过反射来访问它们。
RuntimeInvisibleParameterAnnotations<br/>(Java 5 or higher) | **指定在编译时对于方法参数可见的注解**。 <br/><br/>编译器和注解处理器可以使用这些注解。
RuntimeVisibleTypeAnnotations<br/>(Java 8 or higher) | 指定在运行时对于通用类型，指令等可见的注解。<br/><br/>编译器和注解处理器可以使用这些注解。 代码可以通过反射来访问它们。
RuntimeInvisibleTypeAnnotations<br/>(Java 8 or higher) | 指定在编译时对于通用类型，指令等可见的注解。<br/><br/>编译器和注解处理器可以使用这些注解。
AnnotationDefault<br/>(Java 5 or higher) | **指定注解的默认值**。

## 基本属性（Essential attributes）

ProGuard会自动保留以下基本属性，并在必要时进行处理：

Attribute | Desc
---|---
ConstantValue | 指定常量整数，浮点数，类，字符串等。
Code | 指定方法的实际字节码。
StackMap<br/>(Java Micro Edition) | 提供预验证信息。 Java虚拟机可以在加载类时使用此信息来加快验证步骤。
StackMapTable<br/>(Java 6 or higher) | 提供预验证信息。 Java虚拟机可以在加载类时使用此信息来加快验证步骤。
BootstrapMethods<br/>(Java 7 or higher) | 指定引导动态方法调用的方法。
Module<br/>(Java 9 or higher) | 指定模块的依赖关系。
ModuleMainClass<br/>(Java 9 or higher) | 指定模块的 main 类。
ModulePackages<br/>(Java 9 or higher) | 指定模块的软件包。
NestHost<br/>(Java 11 or higher) | 指定嵌套的宿主类，例如外部类。
NestMembers<br/>(Java 11 or higher) | 指定嵌套的成员，例如内部类。
