# Stream

* [简介](#简介)
* [获取流](#获取流)
* [参考文献](#参考文献)

## 简介

Java 8 API添加了一个支持对元素流进行函数式操作的类 `Stream`，可以让你以一种声明的方式处理数据。

`Stream` 使用一种类似用 SQL 语句从数据库查询数据的直观方式来提供一种对 `Java` 集合运算和表达的高阶抽象。

> Stream API可以极大提高Java程序员的生产力，让程序员写出高效率、干净、简洁的代码。

这种风格将要处理的元素集合看作一种流， 流在管道中传输， 并且可以在管道的节点上进行处理， 比如筛选， 排序，聚合等。

元素流在管道中经过 `中间操作（intermediate operation）` 的处理，最后由 `终端操作(terminal operation)` 得到前面处理的结果。

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




## 参考文献

[https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html](https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html)
