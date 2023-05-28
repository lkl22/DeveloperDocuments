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

## 参考文献

[TypeScript 写一个事件管理器](https://alsritter.icu/docs/%E5%89%8D%E7%AB%AF/JavaScript/TypeScript%20%E7%9B%B8%E5%85%B3/TypeScript%20%E5%86%99%E4%B8%80%E4%B8%AA%E4%BA%8B%E4%BB%B6%E7%AE%A1%E7%90%86%E5%99%A8/)
