package com.lkl.study.feature.stream;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.*;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class StreamTest {
    public static void main(String[] args) {
        createStream();
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
}
