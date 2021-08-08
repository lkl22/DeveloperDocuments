# Stream

* [简介](#简介)
* [获取流](#获取流)
* [流操作和管道](#流操作和管道)
  * [操作状态](#操作状态)
  * [短路操作](#短路操作)
  * [并行性](#并行性)
  * [不干涉](#不干涉)
  * [无状态行为](#无状态行为)
  * [Side-effects](#Sideeffects)
  * [Ordering](#Ordering)
* [Reduction operations](#Reductionoperations)
* [参考文献](#参考文献)

## 简介

Java 8 API添加了一个支持对元素流进行函数式操作的类 `Stream`，可以让你以一种声明的方式处理数据。

`Stream` 使用一种类似用 SQL 语句从数据库查询数据的直观方式来提供一种对 `Java` 集合运算和表达的高阶抽象。

> Stream API可以极大提高Java程序员的生产力，让程序员写出高效率、干净、简洁的代码。

这种风格将要处理的元素集合看作一种流， 流在管道中传输， 并且可以在管道的节点上进行处理， 比如筛选， 排序，聚合等。

元素流在管道中经过 `中间操作（intermediate operation）` 的处理，最后由 `终端操作(terminal operation)` 得到前面处理的结果。

For example:

```java
int sum = widgets.stream()
                 .filter(b -> b.getColor() == RED)
                 .mapToInt(b -> b.getWeight())
                 .sum();
```

流与集合的不同点：

* **没有存储。流不是存储元素的数据结构**；相反，它通过计算操作的管道传送来自数据结构、数组、生成器函数或 I/O 通道等源的元素。
* **功能性。对流的操作会产生结果，但不会修改其源**。例如，过滤从集合中获取的 `Stream` 会生成一个没有过滤元素的新 `Stream`，而不是从源集合中删除元素。
* **延迟执行**。许多流操作，例如过滤、映射或重复删除，可以延迟执行，从而暴露优化机会。例如，“找到第一个具有三个连续元音的String”不需要检查所有输入字符串。流操作分为`中间（Stream-producing）操作`和 `终端（value- or side-effect-producing）操作`。**中间操作总是懒惰的**。
* **可能无界。虽然集合具有有限的大小，但流不需要**。诸如 `limit(n)` 或 `findFirst()` 之类的短路操作可以允许在有限时间内完成对无限流的计算。
* **消耗品。流的元素在流的生命周期内仅被访问一次**。与 `Iterator` 一样，必须生成新的流以重新访问源的相同元素。

## 获取流

可以通过多种方式获得流：

* 从一个 `Collection` 的 `stream()` 和 `parallelStream()` 方法；
* 从一个数组通过 `Arrays.stream(Object[])`;
* 来自流类上的静态工厂方法，例如 `Stream.of(Object[])`, `IntStream.range(int, int)` 或 `Stream.iterate(Object, UnaryOperator)`;
* 文件的行可以从 `BufferedReader.lines()` 获得;
* 文件路径流可以从 `Files` 中的方法获得；
* 可以从 `Random.ints()` 获得随机数流；
* JDK 中的许多其他流承载方法，包括 `BitSet.stream()`、`Pattern.splitAsStream(java.lang.CharSequence)` 和 `JarFile.stream()`。

## 流操作和管道

**流操作分为中间操作和终端操作，结合起来形成流管道**。 流管道由源（例如集合、数组、生成器函数或 I/O 通道）组成； 后跟零个或多个中间操作，例如 `Stream.filter` 或 `Stream.map`； 和一个终端操作，如 `Stream.forEach` 或 `Stream.reduce`。

中间操作返回一个新的流。 他们总是很 lazy； 执行诸如 `filter()` 之类的中间操作实际上并不执行任何过滤，而是创建一个新流，该流在遍历时包含与给定谓词匹配的初始流的元素。 **管道源的遍历直到管道的终端操作被执行后才开始**。

诸如 `Stream.forEach` 或 `IntStream.sum` 之类的终端操作可能会遍历流以产生结果或 side-effect。**执行完终端操作后，流管道被认为已消耗，不能再使用**；如果需要再次遍历同一个数据源，必须返回数据源获取新的流。**在几乎所有情况下，终端操作都是急切的，在返回之前完成对数据源的遍历和管道的处理**。只有终端操作 `iterator()` 和 `spliterator()` 不是；这些是作为“逃生舱口”提供的，以便在现有操作不足以完成任务的情况下启用任意客户端控制的管道遍历。

延迟处理流可以显著提高效率； 在诸如上面的 `filter-map-sum` 示例之类的管道中，过滤、映射和求和可以融合到数据上的单次传递中，中间状态最少。 **Laziness 还可以避免在不必要时检查所有数据**； 对于诸如“查找第一个长度超过 1000 个字符的字符串”之类的操作，只需检查足够多的字符串即可找到具有所需特征的字符串，而无需检查源中所有可用的字符串。 （当输入流是无限的而不仅仅是大时，这种行为变得更加重要。）

### 操作状态

**中间操作进一步分为无状态操作和有状态操作**。

* 无状态操作，例如 `filter` 和 `map`，在处理新元素时不保留先前看到的元素的状态——每个元素都可以独立于其他元素的操作进行处理。
* 在处理新元素时，有状态的操作，例如 `distinct` 和 `sorted`，可能会合并以前看到的元素的状态。

有状态操作可能需要在产生结果之前处理整个输入。例如，在看到流的所有元素之前，无法通过对流进行排序来产生任何结果。因此，在并行计算下，一些包含有状态中间操作的管道可能需要对数据进行多次传递，或者可能需要缓冲重要数据。

包含完全无状态中间操作的管道可以在单次通过中处理，无论是顺序的还是并行的，数据缓冲最少。

### 短路操作

此外，一些操作被视为短路操作。 

* 如果中间操作在呈现无限输入时可能因此产生有限流，则它是短路的。 
* 如果终端操作在无限输入时可能在有限时间内终止，则它是短路的。 

> 在管道中进行短路操作是无限流处理在有限时间内正常终止的必要条件，但不是充分条件。

### 并行性

具有显式 for 循环的处理元素本质上是串行的。 **流通过将计算重新构建为聚合操作的管道而不是每个单独元素上的命令式操作来促进并行执行**。 所有流操作都可以串行或并行执行。 除非明确请求并行性，否则 JDK 中的流实现会创建串行流。 例如，`Collection` 有 `Collection.stream()` 和 `Collection.parallelStream()` 方法，它们分别产生顺序流和并行流； 其他流承载方法，如 `IntStream.range(int, int)` 产生顺序流，但这些流可以通过调用它们的 `BaseStream.parallel()` 方法有效地并行化。 要并行执行先前的“sum of weights of widgets”查询，我们将执行以下操作：

```java
int sumOfWeights = widgets.parallelStream()
                          .filter(b -> b.getColor() == RED)
                          .mapToInt(b -> b.getWeight())
                          .sum();
```

此示例的串行和并行版本之间的唯一区别是创建初始流，使用“`parallelStream()`”而不是“`stream()`”。当启动终端操作时，流管道将根据调用它的流的方向顺序或并行执行。可以使用 `isParallel()` 方法确定流是串行执行还是并行执行，并且可以使用 `BaseStream.sequential()` 和 `BaseStream.parallel()` 操作修改流的方向。**当启动终端操作时，流管道将根据调用它的流的模式顺序或并行执行**。

> 除了标识为显式不确定的操作（例如 `findAny()`）之外，流是顺序执行还是并行执行不应改变计算结果。

大多数流操作接受描述用户指定行为的参数，这些参数通常是 lambda 表达式。 为了保持正确的行为，这些行为参数必须是无干扰的，并且在大多数情况下必须是无状态的。 此类参数始终是函数式接口（例如 Function）的实例，并且通常是 lambda 表达式或方法引用。

### 不干涉

流使您能够对各种数据源执行可能并行的聚合操作，甚至包括非线程安全的集合，例如 `ArrayList`。 **我们只在流管道的执行过程中防止对数据源的干扰**。除了 escape-hatch 操作 `iterator()` 和 `spliterator()`，执行在调用终端操作时开始，并在终端操作完成时结束。**对于大多数数据源来说，防止干扰意味着确保数据源在流管道的执行过程中完全不被修改**。值得注意的例外是其源是并发集合的流，这些流专门设计用于处理并发修改。 并发流源是那些 Spliterator 报告 CONCURRENT 特性的源。

因此，流管道中的行为参数的来源可能不是并发的，永远不要修改流的数据源。如果行为参数修改会导致修改流的数据源，则称行为参数会干扰非并发数据源。**对互不干扰的需求适用于所有管道，而不仅仅是并行管道。**除非流源是并发的，否则在流管道执行期间修改流的数据源可能会导致异常、不正确的答案或不一致的行为。

**对于行为良好的流源，可以在终端操作开始之前修改源，这些修改将反映在涵盖的元素中**。 例如，考虑以下代码：

```java
     List<String> l = new ArrayList(Arrays.asList("one", "two"));
     Stream<String> sl = l.stream();
     l.add("three");
     String s = sl.collect(joining(" "));
```

首先创建一个由两个字符串组成的列表：“one” 和 “two”。 然后从该列表创建一个流。 接下来通过添加第三个字符串 “three” 来修改列表。 最后，流的元素被 collected and joined 在一起。由于列表在终端 `collect` 操作开始之前被修改，结果将是“one two three”。 

从 JDK 集合和大多数其他 JDK 类返回的所有流都以这种方式表现良好； 对于其他库生成的流，请参阅低级流构造以了解构建良好流的要求。

### 无状态行为

**如果流操作的行为参数是有状态的，则流管道结果可能是不确定的或不正确的**。

有状态的 `lambda`（或其他实现适当功能接口的对象）的结果取决于在流管道执行期间可能发生变化的任何状态。 

有状态 `lambda` 的一个例子是 map() 中的参数：

```java
     Set<Integer> seen = Collections.synchronizedSet(new HashSet<>());
     stream.parallel().map(e -> { if (seen.add(e)) return 0; else return e; })...
```

在这里，`map` 操作是并行执行的，由于线程调度差异，相同输入的结果可能会因运行而异，而对于无状态 lambda 表达式，结果将始终相同。

另请注意，尝试从行为参数访问可变状态会给您带来安全和性能方面的错误选择； 如果您不同步对该状态的访问，则会发生数据竞争，因此您的代码会被破坏，但如果您确实同步了对该状态的访问，则可能会因争用而破坏您正在寻求从中受益的并行性。

> 最好的方法是避免有状态的行为参数完成流式传输操作；通常有一种方法可以重构流管道以避免有状态。

### <a name="Sideeffects">Side-effects</a>

**通常不鼓励流操作的行为参数的副作用**，因为它们通常会导致无意中违反无状态要求，以及其他线程安全危险。

如果行为参数确实有副作用，除非明确说明，否则不能保证这些副作用对其他线程的可见性，也**不能保证同一流管道中“相同”元素上的不同操作在同一个线程中执行**。此外，这些效果的排序可能令人惊讶。即使管道被约束以产生与流源的遇到顺序一致的结果（例如， `IntStream.range(0,5).parallel().map(x -> x*2).toArray()` 必须产生 `[0, 2, 4, 6, 8]`)，不保证映射器函数应用于单个元素的顺序，或者任何行为参数在哪个线程中为给定元素执行。

许多可能倾向于使用副作用的计算可以更安全、更有效地表达而没有副作用，例如使用 `reduction` 而不是可变累加器。 但是，诸如将 `println()` 用于调试目的的副作用通常是无害的。 少数流操作，例如 `forEach()` 和 `peek()`，只能通过副作用进行操作； 这些应该小心使用。

作为如何将不当使用副作用的流管道转换为不使用副作用的示例，以下代码在字符串流中搜索与给定正则表达式匹配的字符串，并将匹配项放入列表中。

```java
     ArrayList<String> results = new ArrayList<>();
     stream.filter(s -> pattern.matcher(s).matches())
           .forEach(s -> results.add(s));  // Unnecessary use of side-effects!
```

此代码不必要地使用副作用。 如果并行执行，`ArrayList` 的非线程安全性会导致不正确的结果，并且添加所需的同步会导致争用，破坏并行性的好处。 此外，在这里使用副作用是完全没有必要的； `forEach()` 可以简单地替换为更安全、更高效且更适合并行化的`reduction 操作`：

```java
     List<String> results =
         stream.filter(s -> pattern.matcher(s).matches())
               .collect(Collectors.toList());  // No side-effects!
```

### <a name="Ordering">Ordering</a>

流可能有也可能没有定义的相遇顺序。 流是否具有遇到顺序取决于源和中间操作。某些流源（例如 `List` 或 `arrays`）在本质上是有序的，而其他流源（例如 `HashSet`）则不是。一些中间操作，例如 `sorted()`，可能会在原本无序的流上施加顺序，而其他操作可能会呈现无序的有序流，例如 `BaseStream.unordered()`。 此外，某些终端操作可能会忽略遇到顺序，例如 `forEach()`。

如果流是有序的，则大多数操作都被限制为按元素遇到的顺序对元素进行操作； 如果流的源是一个包含`[1, 2, 3]`的 `List`，那么执行 `map(x -> x*2)` 的结果一定是 `[2, 4, 6]`。 但是，如果源没有定义的相遇顺序，则值 `[2, 4, 6]` 的任何排列都是有效的结果。

**对于顺序流，遇到顺序的存在与否不会影响性能，只会影响确定性**。 

* 如果流是有序的，在相同的源上重复执行相同的流管道将产生相同的结果； 
* 如果没有排序，重复执行可能会产生不同的结果。

**对于并行流，放宽排序约束有时可以实现更高效的执行**。 如果元素的排序不相关，则可以更有效地实现某些聚合操作，例如过滤重复项 (`distinct()`) 或分组reductions (`Collectors.groupingBy()`)。 类似地，本质上与顺序相关的操作，例如 `limit()`，可能需要缓冲以确保正确排序，从而破坏了并行性的好处。 在流具有顺序但用户并不特别关心该顺序的情况下，使用 `unordered()` 显式对流进行 `de-ordering` 可能会提高某些有状态或终端操作的并行性能。 然而，大多数流管道，例如上面的“sum of weight of blocks”示例，即使在排序约束下仍然有效地并行化。

## <a name="Reductionoperations">Reduction operations</a>

`reduction操作（也称为折叠fold）`采用一系列输入元素，并通过重复应用组合操作将它们组合成单个汇总结果，例如查找一组数字的总和或最大值，或将元素累加到列表中 . 流类具有多种形式的通用 reduction操作，称为 `reduce()` 和 `collect()`，以及多种特殊归约形式，如 `sum()`、`max()` 或 `count()`。

当然，这样的操作可以很容易地实现为简单的顺序循环，如：

```java
    int sum = 0;
    for (int x : numbers) {
       sum += x;
    }
```

然而，有充分的理由更喜欢减少操作而不是像上面那样的突变累积。不仅 `reduce` “更抽象”——它作为一个整体而不是单个元素对流进行操作——而且一个正确构造的reduce操作本质上是可并行的，**只要用于处理元素的函数是关联的和无状态的**。

例如，给定一个我们想要求和的数字流，我们可以这样写：

```java
    int sum = numbers.stream().reduce(0, (x,y) -> x+y);
 
or:

    int sum = numbers.stream().reduce(0, Integer::sum);
```

这些 `reduction操作` 几乎不需要修改就可以安全地并行运行：

```java
    int sum = numbers.parallelStream().reduce(0, Integer::sum);
```

`Reduction` 并行化很好，因为实现可以并行操作数据的子集，然后组合中间结果以获得最终的正确答案。（即使该语言具有“`parallel for-each`”构造，可变累积方法仍然需要开发人员为共享累积变量 sum 提供线程安全更新，然后所需的同步可能会消除并行性带来的任何性能增益 .) 使用 `reduce()` 可以消除并行化 `reduction操作` 的所有负担，并且**该库可以提供高效的并行实现，而无需额外的同步**。

前面显示的“widgets”示例显示了reduction如何与其他操作相结合以用批量操作替换 for 循环。 如果 widgets 是一个 Widget 对象的集合，它有一个 getWeight 方法，我们可以找到最重的 widget：

```java
     OptionalInt heaviest = widgets.parallelStream()
                                   .mapToInt(Widget::getWeight)
                                   .max();
```

在更一般的形式中，对 <T> 类型元素的 `reduce` 操作产生 <U> 类型的结果需要三个参数：

```java
<U> U reduce(U identity,
              BiFunction<U, ? super T, U> accumulator,
              BinaryOperator<U> combiner);
```

* 这里，`identity` 元素既是 reduction 的初始值，又是没有输入元素时的默认结果。
* `accumulator` 函数采用部分结果和下一个元素，并产生一个新的部分结果。
* `combiner` 功能组合两个部分结果以产生新的部分结果。 （`combiner` 在并行 reductions 中是必需的，其中输入被分段，为每个分段计算部分堆积，然后将部分结果组合以产生最终结果。）

更正式地说，identity 值必须是 combiner 功能的标识。这意味着对于所有 u，`combiner.apply(identity, u)` 等于 u。此外，`combiner` 函数必须是关联的并且必须与 `accumulator` 函数兼容：对于所有 u 和 t，`combiner.apply(u, accumulator.apply(identity, t))` 必须等于 `accumulator.apply(u, t)`。

三参数形式是二参数形式的推广，将 mapping 步骤合并到 accumulation 步骤中。我们可以使用更通用的形式重新转换简单的 `sum-of-weights` 示例，如下所示：

```java
     int sumOfWeights = widgets.stream()
                               .reduce(0,
                                       (sum, b) -> sum + b.getWeight())
                                       Integer::sum);
```

> 显式的 `map-reduce` 形式更具可读性，因此通常应该是首选。通用形式用于通过将映射和归约组合成单个函数来优化大量工作的情况。


## 参考文献

[https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html](https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html)
