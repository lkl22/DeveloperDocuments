package com.lkl.study.feature.stream;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Widget {
    private Color color;
    private int weight;

    public Color getColor() {
        return color;
    }

    public void setColor(Color color) {
        this.color = color;
    }

    public int getWeight() {
        return weight;
    }

    public void setWeight(int weight) {
        this.weight = weight;
    }

    public static List<Widget> genRandomWidgets(int count) {
        Random random = new Random();
        List<Widget> widgets = new ArrayList<>();
        Widget widget;
        for (int i = 0; i < count; i++) {
            widget = new Widget();
            widget.setColor(Color.values()[random.nextInt(Color.values().length)]);
            widget.setWeight(random.nextInt());
            widgets.add(widget);
        }
        return widgets;
    }

    public enum Color {
        RED, BLUE, GREY, GREEN
    }
}


