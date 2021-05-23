# Configuration - Optimizations

可以使用 `-dontoptimize` 选项关闭ProGuard的优化步骤。要对各个优化进行更细粒度的控制，专家可以使用 `-optimizations` 选项，并根据以下列出的优化名称使用过滤器。 过滤器的工作方式与ProGuard中的任何过滤器一样。

支持以下通配符：

通配符（WILDCARD） |	含义（MEANING）
---|---
? | 匹配优化名称中的任何单个字符。
\* | 与优化名称的任何部分匹配。

前面带有感叹号 `“!”` 的优化不再与过滤器中的后续优化名称匹配的尝试被排除在外。确保正确指定过滤器，因为不会检查它们是否存在潜在的错别字。

例如，`"code/simplification/variable,code/simplification/arithmetic"` 仅执行两个指定的 peephole 优化。

例如，`"!method/propagation/*"` 执行所有优化，除了那些在方法之间传播值的优化。

例如，`"!code/simplification/advanced,code/simplification/*"` 仅执行所有 peephole 优化。

一些优化必然意味着其他优化。 然后表明这些。 请注意，随着优化的添加和重新组织，该列表可能会针对较新的版本而更改。

Optimization | Decs
---|---
library/gson | 尽可能优化Gson库的使用。
class/marking/final | 尽可能将class标记为final class。
class/unboxing/enum | 尽可能将枚举类型简化为整数常量。
class/merging/vertical | 尽可能在类层次结构中垂直合并类。
class/merging/horizontal | 尽可能在类层次结构中水平合并类。
class/merging/wrapper | 尽可能将包装器类与其包装的类合并。
field/removal/writeonly<br/>(â‡’ code/removal/advanced) | 删除只写字段。
field/marking/private | 尽可能将字段标记为私有。
field/generalization/class | 尽可能概括字段访问的类别。
field/specialization/type | 尽可能明确字段类型
field/propagation/value<br/>(â‡’ code/simplification/advanced) | 在各个方法之间传播字段的值。
method/marking/private | 尽可能将方法标记为私有（去虚拟化）。
method/marking/static<br/>(â‡’ code/removal/advanced) | 尽可能将方法标记为静态（去虚拟化）。
method/marking/final | 尽可能将方法标记为 final 方法。
method/marking/synchronized | 尽可能将方法取消标记为同步。
method/removal/parameter<br/>(â‡’ code/removal/advanced) | 删除未使用的方法参数。
method/generalization/class | 尽可能概括方法调用的类。
method/specialization/parametertype | 尽可能明确方法参数的类型。
method/specialization/returntype | 尽可能明确方法返回值的类型。
method/propagation/parameter<br/>(â‡’ code/simplification/advanced) | 将方法参数的值从方法调用传播到被调用的方法。
method/propagation/returnvalue<br/>(â‡’ code/simplification/advanced) | 将方法返回值的值从方法传播到其调用。
method/inlining/short | 内联短方法。
method/inlining/unique | 内联仅调用一次的方法。
method/inlining/tailrecursion | 尽可能简化尾递归调用。
code/merging | 通过修改分支目标合并相同的代码块。
code/simplification/variable | 执行 peephole 优化以进行变量加载和存储。
code/simplification/arithmetic | 对算法指令执行 peephole 优化。
code/simplification/cast | 对 casting 操作执行 peephole 优化。
code/simplification/field | 对 field 加载和存储执行 peephole 优化。
code/simplification/branch<br/>(â‡’ code/removal/simple) | 对分支指令执行 peephole 优化。
code/simplification/object | 对对象实例执行 peephole 优化。
code/simplification/string | 对常量字符串执行 peephole 优化。
code/simplification/math | 对Math方法调用执行 peephole 优化。
code/simplification/advanced<br/>(best used with code/removal/advanced) | 基于控制流分析和数据流分析简化代码。
code/removal/advanced<br/>(â‡’ code/removal/exception) | 根据控制流分析和数据流分析删除无效代码。
code/removal/simple<br/>(â‡’ code/removal/exception) | 基于简单的控制流分析，删除无效代码。
code/removal/variable | 从局部变量 frame 中删除未使用的变量。
code/removal/exception | 删除带有空try块的异常。
code/allocation/variable | 优化局部变量 frame 上的变量分配。

ProGuard还提供了一些非官方的设置来控制优化，这些设置可能会在将来的版本中消失。 这些是Java系统属性，可以将其设置为JVM参数（使用-D ...）：

Optimization | Decs
---|---
maximum.inlined.code.length <br/>(default = 8 bytes) | 指定有资格内联的短方法的最大代码长度（以字节表示）。 <br/><br/>内联方法过长可能会不必要地增加代码大小。
maximum.resulting.code.length <br/>(default = 8000 bytes for JSE, 2000 bytes for JME) | 指定内联方法时允许的最大结果代码长度（以字节表示）。 <br/><br/>许多Java虚拟机不会将即时编译应用于太长的方法，因此重要的是不要让它们变得太大。
optimize.conservatively <br/>(default = unset) | 允许带有普通指令的输入代码有意抛出 `NullPointerException`，`ArrayIndexOutOfBoundsException` 或 `ClassCastException`，而没有任何其他有用的用途。<br/><br/>默认情况下，ProGuard可能只是丢弃这些看似无用的指令，从而更好地优化了大多数通用代码。

## Gson optimization

ProGuard通过检测使用Gson库序列化了哪些 domain 类来优化Gson代码。 它用注入和优化的代码替换了基于反射的GSON实现，以读取和写入fields，该代码在读取和写入JSON时直接访问 domain 类的 fields。 此优化的好处如下：

* 与GSON结合使用的 domain 类可以自由地进行混淆处理。
* 与依赖反射的GSON实现相比，注入的序列化代码可提供更好的性能。
* 所需的配置更少，因为优化会自动保留序列化所需的类和字段。

## Configuration

**Gson优化默认情况下处于启用状态**，并且不需要任何其他配置，只要应用程序代码不使用不受支持的Gson功能（请参阅已知限制）即可。

## 已知限制（Known limitations）

ProGuard无法优化以下Gson用例：

* 序列化包含以下Gson注解之一的类：`@JsonAdapter` `@Since` `@Until`
* 序列化签名中具有通用类型变量的类。
* 使用通过`GsonBuilder`上的以下设置之一构建的Gson实例序列化类：`excludeFieldsWithModifier` `setFieldNamingPolicy`

使用上述Gson功能之一时，ProGuard会自动为所有受影响的 domain 类保留原始的Gson实现。

这意味着这些 domain 类的序列化字段需要再次明确地保留在DexGuard配置中，以便可以通过反射安全地访问它们。
