package com.lkl.study.feature.stream;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class StreamTest {
    public static void main(String[] args) {
        createStream();
        intermediateOperation();
        terminalOperation();
    }

    private static void createStream() {
        List<String> list = new ArrayList<String>() {//这个大括号 就相当于我们  new 接口
            {//这个大括号 就是 构造代码块 会在构造函数前 调用
                this.add("hi");
                this.add("sorry");
                this.add("hello");
                this.add("word");
            }
        };
        // 从一个 Collection 的 stream() 和 parallelStream() 方法
        list.stream().map(it -> it + " dd").forEach(System.out::println);
        // 并发不保证执行顺序
        list.parallelStream().map(it -> it + " dd").forEach(System.out::println);

        String[] array = new String[]{
                "one", "two", "three"
        };
        // 从一个数组通过 Arrays.stream(Object[])
        Arrays.stream(array).map(it -> it + " dd").forEach(System.out::println);

        // 来自流类上的静态工厂方法
        IntStream.range(1, 5).forEach(System.out::println);
        // 无限流
        Stream.iterate(1, s -> {
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return s + 1;
        }).forEach(System.out::println);

        // 文件的行可以从 BufferedReader.lines() 获得
        try {
            new BufferedReader(new FileReader("./test.txt")).lines().forEach(System.out::println);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        // 从 Random.ints() 获得随机数流
        new Random().ints(3, 1, 20).forEach(System.out::println);
    }

    private static void intermediateOperation() {
        String[] array = new String[]{
                "one, two", "four, five", "two, three", "three, four", "one, two", "six", "ten", "five", "three"
        };

        Arrays.stream(array)
                .filter(s -> s.startsWith("t"))
                .forEach(System.out::println);

        Arrays.stream(array)
                .map(s -> s.split(","))
                .flatMap(Arrays::stream)
                .peek(s -> System.out.println("flatMap -> " + s))
                .map(String::trim)
                .distinct()
                .sorted((String::compareTo))
                .limit(3)
                .skip(1)
                .forEach(System.out::println);
    }

    private static void terminalOperation() {
        int[] array = new int[]{
                1, 2, 3, 4, 5, 2, 1, 3, 7
        };
        // reduce((T, T) -> T) 不接受任何起始值，但因为没有初始值，需要考虑结果可能不存在的情况，因此返回的是 Optional 类型
        OptionalInt res = Arrays.stream(array).reduce(Integer::sum);
        // reduce(T, (T, T) -> T) reduce 第一个参数 0 代表起始值为 0
        int res1 = Arrays.stream(array).reduce(0, Integer::sum);

        List<Widget> widgetList = Widget.genRandomWidgets(10);
        // reduce(R, (R, T) -> R, (R, R) -> R)
        int sumOfWeights = widgetList.stream().reduce(0, (sum, b) -> sum + b.getWeight(), Integer::sum);
        System.out.println("res = " + res + " res1 = " + res1 + " sumOfWeights = " + sumOfWeights);

        ArrayList<String> strings = Arrays.stream(array).collect(ArrayList::new, (c, e) -> c.add(e + ""), ArrayList::addAll);
        System.out.println(strings);

        List<String> weights = widgetList.stream().map(t -> t.getWeight() + "").collect(Collectors.toList());
        System.out.println(weights);

        OptionalInt min = Arrays.stream(array).min();
        OptionalInt max = Arrays.stream(array).max();
        long count = Arrays.stream(array).count();
        System.out.println("min = " + min + " max = " + max + " count = " + count);

        boolean anyMatch = Arrays.stream(array).anyMatch(t -> t > 5);
        boolean allMatch = Arrays.stream(array).allMatch(t -> t > 5);
        boolean noneMatch = Arrays.stream(array).noneMatch(t -> t > 5);
        System.out.println("anyMatch = " + anyMatch + " allMatch = " + allMatch + " noneMatch = " + noneMatch);

        OptionalInt findAny = Arrays.stream(array).parallel().findAny();
        OptionalInt findFirst = Arrays.stream(array).findFirst();
        System.out.println("findAny = " + findAny + " findFirst = " + findFirst);
    }
}
