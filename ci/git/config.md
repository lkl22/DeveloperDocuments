#### 配置全局环境变量

文档：[https://git-scm.com/docs/git-config](https://git-scm.com/docs/git-config)

```markdown
git config --list // 查看配置
git config --global user.name "xxx"
git config --global user.email "xxx@163.com"
git config --global gui.encoding utf-8
```

* Git可以在你提交时自动地把行结束符CRLF转换成LF，而在签出代码时把LF转换成CRLF。用`core.autocrlf`来打开此项功能， 如果是在Windows系统上，把它设置成`true`，这样当签出代码时，LF会被转换成CRLF：

> $ git config --global core.autocrlf true

Linux或Mac系统使用LF作为行结束符，因此你不想Git在签出文件时进行自动的转换；当一个以CRLF为行结束符的文件不小心被引入时你肯定想进行修正， 把`core.autocrlf`设置成input来告诉Git在提交时把CRLF转换成LF，签出时不转换：

> $ git config --global core.autocrlf input

这样会在Windows系统上的签出文件中保留CRLF，会在Mac和Linux系统上，包括仓库中保留LF。

* 在使用git的时候，经常会碰到有一些中文文件名或者路径被转义成\xx\xx\xx之类的，此时可以通过git的配置来改变默认转义具体命令如下：

> $ git config --global core.quotepath false

#### 配置提交分支

当执行push命令时，将会推送到refs/for/当前head所在的分支上，不会直接推送到gerrit的合并分支上，需要人工合代码

> git config remote.origin.push refs/heads/\*:refs/for/\*



