# Configuration - Usage

按逻辑分组列出了ProGuard的所有可用选项。

* [Input/Output Options](#InputOutputOptions)
* [Keep Options](#KeepOptions)

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

## <a name="Keep Options">Keep Options<a/>


