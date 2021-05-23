# Configuration - Usage

按逻辑分组列出了ProGuard的所有可用选项。

* [Input/Output Options](#InputOutputOptions)
* [Keep Options](#KeepOptions)
* [File Names](#FileNames)
* [File Filters](#FileFilters)
* [Keep Option Modifiers](#KeepOptionModifiers)
* [Class Specifications](#ClassSpecifications)

## <a name="InputOutputOptions">Input/Output Options<a/>

Option | Desc
---|---
@ filename | Short for '-include filename'.
-include filename | 从给定的文件名中递归读取配置选项。
-basedirectory directoryname | 在这些配置参数或此配置文件中，为所有后续相对文件名指定基本目录。
-injars class_path | 指定要处理的应用程序的输入jar（或apk，aab，ars，wars，ears，jmods，zip或目录）。<br/><br/>这些jars中的类文件将被处理并写入输出jars中。<br/><br/>默认情况下，所有非类文件都将被复制而不会更改。 请注意任何临时文件（例如由IDE创建的临时文件），尤其是当您直接从目录中读取输入文件时。 可以过滤类路径中的条目，如过滤器部分所述。<br/><br/>为了提高可读性，可以使用多个-injars选项指定类路径条目。
-outjars class_path | 指定输出jar的名称（或apk，aab，ars，wars，ears，jmods，zip或目录）。<br/><br/>前面的 -injars 选项的处理后的输入将被写入命名的jar。<br/><br/>这使您可以将一组输入jar的内容收集到对应的一组输出jar中。 此外，可以过滤输出条目，如过滤器部分所述。 然后，将每个已处理的类文件或资源文件通过一组匹配的过滤器写入输出jar组中的第一个输出条目。 <br/><br/>**您必须避免让输出文件覆盖任何输入文件**。<br/><br/>为了提高可读性，可以使用多个-outjars选项指定类路径条目。 如果没有任何-outjars选项，则不会写入任何jar。
-libraryjars class_path | 指定要处理的应用程序的库jar（或apk，aab，aars，wars，ears，jmods，zips，目录）。<br/><br/>这些jar中的文件将不包含在输出jar中。<br/><br/>指定的库jar至少应包含由应用程序类文件扩展的类文件。尽管只存在被调用的库类文件，但是它们的存在可以改善优化步骤的结果，尽管它们不需要存在。可以过滤类路径中的条目，如过滤器部分所述。<br/><br/>为了提高可读性，可以使用多个-libraryjars选项指定类路径条目。<br/><br/>请注意，在查找库类时，不会考虑为运行ProGuard设置的引导路径和类路径。这意味着您必须明确指定代码将使用的运行时jar。尽管这看起来很麻烦，但是它允许您处理针对不同运行时环境的应用程序。例如，您只需指定适当的运行时jar，就可以处理J2SE应用程序以及JME midlet或Android应用程序。
-skipnonpubliclibraryclasses | 指定在读取库jar时跳过非公共类，以加快处理速度并减少ProGuard的内存使用量。<br/><br/>默认情况下，ProGuard会读取非公共和公共库类。 但是，非公共类通常不相关，只要它们不影响输入jar中的实际程序代码即可。 然后忽略它们可以加快ProGuard的速度，而不会影响输出。 不幸的是，某些库，包括最近的JSE运行时库，都包含由公共库类扩展的非公共库类。 然后，您将无法使用此选项。<br/><br/>如果由于设置了此选项而无法找到 classes，则ProGuard将打印警告。
-dontskipnonpubliclibraryclasses | 指定不忽略非公共库类。 从4.5版开始，这是默认设置。
-dontskipnonpubliclibraryclassmembers | 指定不忽略包可见的库类成员（字段和方法）。<br/><br/>默认情况下，ProGuard在解析库类时会跳过这些类成员，因为程序类通常不会引用它们。 但是，有时程序类与库类位于相同的程序包中，并且它们确实引用其程序包可见的类成员。 在这些情况下，实际读取类成员可能很有用，以确保所处理的代码保持一致。
-keepdirectories [directory_filter] | 指定要保留在输出jar中的目录（或apk，aab，aar，wars，ears，jmods，zip或目录）。<br/><br/>默认情况下，目录条目被删除。 这样可以减小jar的大小，但是如果代码尝试使用“com.example.MyClass.class.getResource("")“之类的结构来查找它们，则可能会破坏您的程序。 然后，您将想要保留与包相对应的目录“ -keepdirectories com.example”。 如果指定的选项没有过滤器，则保留所有目录。 使用过滤器时，仅保留匹配的目录。<br/><br/>“-keepdirectories mydirectory”与指定目录匹配，<br/><br/>“-keepdirectories mydirectory/*”与其直接子目录匹配，<br/><br/>“-keepdirectories mydirectory/\**”匹配其所有子目录。
-target version | 指定要在已处理的类文件中设置的版本号。 版本号可以是1.0，...，1.9或更新的短数字5，...，12之一。<br/><br/>默认情况下，类文件的版本号保持不变。<br/><br/>例如，您可能需要将类文件升级到Java6。ProGuard更改其版本号并对其进行预验证。 您也可以将类文件降级到Java 8之前的版本。ProGuard更改其版本号并向后移植Java 8构造。<br/><br/>如果分别添加了向后移植的库 net.sourceforge.streamsupport 和 org.threeten 作为输入，则ProGuard通常不会向后移植Java运行时中的更改，除了 Java 8 stream API 和 Java 8 date API 之外。
-forceprocessing | 指定处理输入，即使输出看起来是最新的也是如此。<br/><br/>最新测试基于指定输入，输出和配置文件或目录的日期戳的比较。

## <a name="KeepOptions">Keep Options<a/>

Option | Desc
---|---
-keep [,[modifier](#KeepOptionModifiers),...] [class_specification](#ClassSpecifications) | 指定要保留为代码 entry points 的类和类成员（字段和方法）。 例如，为了保留应用程序，您可以指定 main 类及其 main 方法。<br/><br/>为了处理库，您应该指定所有可公开访问的元素。
-keepclassmembers [,[modifier](#KeepOptionModifiers),...] [class_specification](#ClassSpecifications) | 指定要保留的类成员，它们的类也被保留。<br/><br/>例如，您可能想要保留实现Serializable接口的所有序列化字段和类的方法。
-keepclasseswithmembers [,[modifier](#KeepOptionModifiers),...] [class_specification](#ClassSpecifications) | 在存在所有指定的类成员的条件下，指定要保留的类和类成员。<br/><br/>例如，您可能希望保留所有具有main方法的应用程序，而不必显式列出它们。
-keepnames [class_specification](#ClassSpecifications) | **-keep, allowshrinking class_specification** 的缩写<br/><br/>指定要保留名称的类和类成员（如果在压缩阶段未删除它们）。<br/><br/>例如，您可能想要保留实现Serializable接口的类的所有类名，以便处理后的代码与任何原始序列化的类保持兼容。 完全不使用的类仍可以删除。 仅在混淆时适用。
-keepclassmembernames [class_specification](#ClassSpecifications) | **-keepclassmembers, allowshrinking class_specification** 的缩写<br/><br/>指定要保留名称的类成员（如果在压缩阶段未删除它们）。 <br/><br/>例如，在处理由JDK 1.2或更早版本编译的库时，您可能想保留合成 class$ 方法的名称，因此混淆器可以在处理使用处理后的库的应用程序时再次检测到它（尽管ProGuard本身不需要这）。仅在混淆时适用。
-keepclasseswithmembernames [class_specification](#ClassSpecifications) | **-keepclasseswithmembers,allowshrinking class_specification** 的缩写<br/><br/>指定要保留其名称的类和类成员，条件是所有指定的类成员在压缩阶段之后都存在。<br/><br/>例如，您可能希望保留所有 native 方法名称及其类的名称，以便处理后的代码仍可以与 native 库代码链接。 完全不使用的 native 方法仍然可以删除。<br/><br/>如果使用了类文件，但没有使用其 native 方法，则其名称仍会被混淆。 仅在混淆时适用。
-if [class_specification](#ClassSpecifications) | 指定激活后续的keep选项必须存在的类和类成员（-keep，-keepclassmembers等）。<br/><br/>条件和随后的keep选项可以共享通配符和对通配符的引用。<br/><br/>例如，可以使用Dagger和Butterknife之类的框架，在项目中存在具有相关名称的类的情况下保留类。
-printseeds [[filename](#FileNames)] | **指定输出详尽列出与各种-keep选项匹配的类和类成员**。<br/><br/>该列表将打印到标准输出或给定的文件中。<br/><br/>该列表对于验证是否确实找到了预期的类成员很有用，尤其是在您使用通配符的情况下。<br/><br/>例如，您可能要列出所有应用程序或所保留的所有小程序。



## <a name="FileNames">File Names<a/>

ProGuard接受各种文件名和目录名的绝对路径和相对路径。 相对路径解释如下：

1. 相对于基本目录（如果已设置），否则
2. 相对于在其中指定配置文件的位置（如果有），否则
3. 相对于工作目录。

名称可以包含Java系统属性（或使用Ant时的Ant属性），并用尖括号 “<” 和 “>” 定界。 这些属性将自动替换为其相应的值。

例如，_<java.home>/lib/rt.jar_ 会自动扩展为 _/usr/local/java/jdk/jre/lib/rt.jar_。 同样，<user.home> 扩展到用户的主目录，而 <user.dir> 扩展到当前工作目录。

带有特殊字符（如空格和括号）的名称必须用单引号或双引号引起来。 **名称列表中的每个文件名都必须单独引用**。 请注意，在命令行上使用引号本身时可能需要转义，以避免被shell吞噬。

例如，在命令行上，您可以使用 `'-injars "my program.jar":"/your directory/your program.jar"'` 之类的选项。

## <a name="FileFilters">File Filters<a/>

与常规过滤器一样，文件过滤器是逗号分隔的文件名列表，其中可以包含通配符。 只有具有匹配文件名的文件才被读取（对于 输入jars 而言）或被写入（对于 输出jars 而言）。 支持以下通配符：

通配符（WILDCARD） |	含义（MEANING）
---|---
？ | 匹配文件名中的任何单个字符。
\* | 匹配文件名中不包含目录分隔符的任何部分。
\*\* | 匹配文件名的任何部分，可能包含任意数量的目录分隔符。

例如，`"java/**.class,javax/**.class"` 与 `java` 和 `javax` 中的所有类文件匹配。

此外，文件名之前可以带有感叹号“!”。 进一步尝试从与后续文件名匹配的文件名中排除该文件名。

例如，`"!**.gif,images/**"` 匹配images目录中的所有文件，但gif文件除外。




## <a name="KeepOptionModifiers">Keep Option Modifiers<a/>

Modifier | Desc
---|---
includedescriptorclasses | 指定-keep选项保留的方法和字段的类型描述符中的所有类也应保留。<br/><br/>这在保留 native 方法名称时通常很有用，以确保 native 方法的参数类型也不会重命名。然后，它们的签名将保持完全不变，并与 native 库兼容。
includecode | 指定-keep选项保留的方法的代码属性也应保留，即可能不会被优化或混淆。<br/><br/>这对于已优化或混淆的类通常很有用，以确保在优化过程中未修改其代码。
allowshrinking | 指定-keep选项中指定的 entry points 可以缩小，即使必须保留这些 entry points 也可以。<br/><br/>也就是说，可以在压缩步骤中删除 entry points ，但是，如果有必要，则可能不会对其进行优化或混淆。
allowoptimization | 指定可以优化-keep选项中指定的 entry points ，即使必须保留这些 entry points 也是如此。 也就是说，可以在优化步骤中更改 entry points ，但不能将其删除或混淆。<br/><br/>此修饰符仅在实现不寻常的要求时有用。
allowobfuscation | 指定-keep选项中指定的 entry points 可能会被混淆，即使必须保留这些 entry points 也是如此。 即， entry points 可以在混淆步骤中重命名，但是它们可能不会被删除或优化。 <br/><br/>此修饰符仅在实现不寻常的要求时有用。

## <a name="ClassSpecifications">Class Specifications<a/>

类规范是类和类成员（字段和方法）的模板。 它在各种 **-keep选项** 和 **-assumenosideeffects选项** 中使用。 相应的选项仅适用于与模板匹配的类和类成员。

该模板的设计看起来非常像Java，带有一些通配符扩展名。 为了了解语法，您可能应该看一下示例，但这是对完整的正式定义的尝试：

```
[@annotationtype] [[!]public|final|abstract|@ ...] [!]interface|class|enum classname
    [extends|implements [@annotationtype] classname]
[{
    [@annotationtype]
    [[!]public|private|protected|static|volatile|transient ...]
    <fields> | (fieldtype fieldname [= values]);

    [@annotationtype]
    [[!]public|private|protected|static|synchronized|native|abstract|strictfp ...]
    <methods> | <init>(argumenttype,...) | classname(argumenttype,...) | (returntype methodname(argumenttype,...) [return values]);
}]
```

方括号“ []”表示其内容是可选的。 省略号“ ...”表示可以指定任意数量的前述项目。 竖线“ |” 界定两个选择。 非粗体括号“（）”仅将规范中属于同一部分的部分组合在一起。 缩进试图阐明预期的含义，但是空格与实际配置文件无关。

class关键字指的是任何接口或类。 interface关键字将匹配项限制为接口类。 enum关键字将匹配项限制为枚举类。 在接口或枚举关键字之前加 ! 将匹配分别限制为不是接口或枚举的类。

每个类名必须 fully qualified，例如 java.lang.String。 内部类之间用美元符号 “$” 分隔，例如 java.lang.Thread$State。 可以将类名指定为包含以下通配符的正则表达式：

通配符（WILDCARD） |	含义（MEANING）
---|---
？| **匹配类名称中的任何单个字符，但不匹配包分隔符**。 <br/><br/>例如，“ com.example.Test？” 匹配 “ com.example.Test1” 和 “ com.example.Test2”，但不匹配“ com.example.Test12”。
\* | **与不包含包分隔符的类名的任何部分匹配**。 <br/><br/>例如，“ com.example.*Test*” 匹配“ com.example.Test” 和 “ com.example.YourTestApplication”，但不匹配 “ com.example.mysubpackage.MyTest”。 <br/>或者，更一般而言，“ com.example.*” 匹配 “ com.example” 中的所有类，但不匹配其子包中的所有类。
\*\* | **匹配类名的任何部分，可能包含任意数量的包分隔符**。 <br/><br/>例如，“ **.Test” 匹配除根包以外的所有包中的所有Test类。 <br/>或者，“ com.example.\**” 与 “ com.example” 及其子包中的所有类匹配。
\<n> | **在相同选项中匹配第n个匹配的通配符**。 <br/><br/>例如，“ com.example.*Foo<1>” 与 “ com.example.BarFooBar” 匹配。

为了获得更大的灵活性，类名实际上可以是用逗号分隔的类名列表，并带有可选的 ! 否定符，就像文件名过滤器一样。 这种表示法看起来不太像Java，因此应适度使用。 为了方便和向后兼容，类名*表示任何类，无论其包如何。

extends and implements 通常用于使用通配符来限制类。 它们当前是等效的，指定仅扩展或实现（直接或间接）给定类的类才有资格。 给定的类本身不包含在此集合中。 如果需要，应在单独的选项中指定。

@ 规范可用于将类和类成员限制为使用指定注释类型进行注释的成员。 指定注释类型就像类名一样。

字段和方法的指定与Java中的指定非常相似，除了方法参数列表不包含参数名称（就像在Javadoc和javap等其他工具中一样）。 规范还可以包含以下所有通配符：

通配符（WILDCARD） |	含义（MEANING）
---|---
\<init>	| matches any constructor.
\<fields> |	matches any field.
\<methods> |	matches any method.
\*	| matches any field or method.

> 请注意，上述通配符没有返回类型。 仅\<init>通配符具有参数列表。

字段和方法也可以使用正则表达式指定。 名称可以包含以下通配符：

通配符（WILDCARD） |	含义（MEANING）
---|---
? | 匹配方法名称中的任何单个字符。
\* | 匹配方法名称的任何部分。
\<n> | 在相同选项中匹配第n个匹配的通配符。

描述符中的类型可以包含以下通配符：

通配符（WILDCARD） |	含义（MEANING）
---|---
％ | 匹配任何 primitive 类型（“boolean”，“int” 等，但不匹配 “void”）。
？ | 匹配类名称中的任何单个字符。
\* | 与不包含包分隔符的类名的任何部分匹配。
\*\* | 匹配类名的任何部分，可能包含任意数量的包分隔符。
\*\*\* | 匹配任何类型（primitive or non-primitive, array or non-array）。
... | 匹配任意数量的任何类型的参数。
\<n> | 在相同选项中匹配第n个匹配的通配符。

> 请注意，？，\* 和 \*\* 通配符将永远与 primitive 类型不匹配。此外，仅***通配符将匹配任何维度的数组类型。

例如，“ \*\* get*()” 匹配 “ java.lang.Object getObject()”，但不匹配“ float getFloat()”，也不匹配“ java.lang.Object[] getObjects()”。

也可以使用其简短的类名（不带包）或使用其完整的类名来指定构造函数。 与Java语言一样，构造函数规范具有参数列表，但没有返回类型。

类访问修饰符和类成员访问修饰符通常用于限制通配符的类和类成员。 它们指定必须设置相应的访问标志以使成员匹配。前面的 ! 指定应取消设置相应的访问标志。

允许组合多个标志（例如public static）。 这意味着必须设置两个访问标志（例如公共和静态），除非它们发生冲突，否则必须至少设置其中一个（例如至少 public or protected）。

ProGuard支持合成器，桥接器和可变参数等附加修饰符，这些修饰符可由编译器设置。

使用 **-assumevalues 选项**，具有 primitive 返回类型的字段和方法可以具有值或 ranges of values。**assignment 关键字**是 = 或 return，可以互换。例如，"boolean flag = true;" or "int method() return 5;"。 值的范围以..分隔，例如 “ int f = 100..200;”。 范围包括其开始值和结束值。
