* #### 解决：IntelliJ IDEA 编译错误，提示 Compilation failed: internal java compiler error

原因可能是项目指定的JDK与当前环境JDK不符合，解决办法：**File -&gt; Setting -&gt; Compiler -&gt; Java Compiler**，在相应的module中选择合适的JDK版本（_**Target bytecode version**_修改为合适的）。![](/assets/Idea/idea_issue_1.png)

