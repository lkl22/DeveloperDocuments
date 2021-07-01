package com.lkl.algorithm.swingBasics;

import javax.swing.*;
import java.awt.*;

public class AboutJavaGUI {
    public static void main(String[] args) {
        // write your code here
        EventQueue.invokeLater(() -> {
            JFrame frame = new JFrame("Welcome");
            // 设置窗口大小
            frame.setSize(500, 500);
            // 设置不能调整窗口大小
            frame.setResizable(false);
            // 设置默认的close操作
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            // 设置显示，否则不会出来
            frame.setVisible(true);
        });
    }
}
