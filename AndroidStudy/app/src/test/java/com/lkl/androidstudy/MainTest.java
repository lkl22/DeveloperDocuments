package com.lkl.androidstudy;

import org.junit.Test;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class MainTest {
    public static void main(String[] args) {
        System.out.println("hello word!");
    }

    @Test
    public void testMain() throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        Class<?> cls = MainTest.class;
        Method mainMethod = cls.getDeclaredMethod("main", String[].class);
        String[] args = new String[]{"2021", "07", "31"};
        mainMethod.invoke(null, (Object) args);
        mainMethod.invoke(null, new Object[]{args});
    }
}
