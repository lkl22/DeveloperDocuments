[https://reactjs.org/docs/react-component.html\#state](https://reactjs.org/docs/react-component.html#state)

**state**包含特定于此组件的数据，该数据可能会随时间而变化。 **state**是用户定义的，它应该是一个普通的**JavaScript**对象。

如果某些值未用于呈现或数据流（例如，计时器ID），则不必将其置于**state**。 可以将此类值定义为组件实例上的字段**fields **。

永远不要直接改变this.state，因为之后调用setState（）可能会替换你所做的突变。 把this.state看作是不可变的。

---

[https://reactjs.org/docs/state-and-lifecycle.html](#)

## 正确使用setState需要注意的三点：

* **除了在constructor中其他任意地方不能直接修改state的值**

For example, this will not re-render a component:

```js
// Wrong
this.state.comment ='Hello';
```

Instead, use`setState()`:

```js
// Correct
this.setState({comment:'Hello'});
```

The only place where you can assign`this.state`is the constructor.

* **状态更新可能是异步的**

React可以将多个setState\(\) 调用批处理为单个更新以提高性能。

因为this.props和this.state可以异步更新，所以不应该依赖它们的值来计算下一个状态。

For example, this code may fail to update the counter:

```js
// Wrong
this.setState({
  counter: this.state.counter + this.props.increment,
});
```

To fix it, use a second form of`setState()`that accepts a function rather than an object. That function will receive the previous state as the first argument, and the props at the time the update is applied as the second argument:

要修复它，请使用第二种形式的setState\(\) 接受函数而不是对象。 该函数将接收先前的state作为第一个参数，并将props作为第二个参数：

```js
// Correct
this.setState((prevState, props) => ({
  counter: prevState.counter + props.increment
}));
```

* **状态更新合并**

当您调用setState\(\) 时，React会将您提供的对象合并到当前状态。

例如，您state可能包含几个独立变量：

```js
constructor(props) {
    super(props);
    this.state = {
      posts: [],
      comments: []
    };
  }
```

然后，您可以使用单独的setState\(\) 调用独立更新它们：

```js
componentDidMount() {
    fetchPosts().then(response => {
      this.setState({
        posts: response.posts
      });
    });

    fetchComments().then(response => {
      this.setState({
        comments: response.comments
      });
    });
  }
```

合并很浅，因此this.setState（{comments}）保留了this.state.posts，但完全取代了this.state.comments。

