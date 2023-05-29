# 实现单例

编写一个单例的基类：

```scripe
export default class Singleton {
  static getInstance<T extends {}>(this: new () => T): T {
    if (!(<any> this).instance) {
      (<any> this).instance = new this();
    }
    return (<any> this).instance;
  }
}
```

上面实现的单例会在类继承时有问题，比如 A extends Singleton，B extends A，在先 A.getInstance()，再执行 B.getInstance()方法时，会是同一个对象，这是由于原型链的原因，可以使用下面的方式打破原型链：

```scripe
export default class Singleton {
  public static getInstance<T extends {}>(this: new () => T): T {
    if (!Object.getOwnPropertyDescriptor(<any> this, 'instance')) {
      (<any> this).instance = new this();
    }
    return (<any> this).instance;
  }
}
```

## 参考文献

[TypeScript 写一个事件管理器](https://alsritter.icu/docs/%E5%89%8D%E7%AB%AF/JavaScript/TypeScript%20%E7%9B%B8%E5%85%B3/TypeScript%20%E5%86%99%E4%B8%80%E4%B8%AA%E4%BA%8B%E4%BB%B6%E7%AE%A1%E7%90%86%E5%99%A8/)
