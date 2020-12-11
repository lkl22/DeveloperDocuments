[https://github.com/golang/go](https://github.com/golang/go)

[https://studygolang.com/](https://studygolang.com/)

开发工具：[https://www.jetbrains.com/go/](https://www.jetbrains.com/go/) 或者 [http://liteide.org/cn/](http://liteide.org/cn/)

windows下liteide代码智能补齐功能：

1、windows环境变量配置：

```markdown
GOROOT=D:\Go
GOBIN=F:\GolangProjects\bin //生成bin文件的路径
GOOS=windows
GOARCH=amd64
GOPATH=F:\GolangProjects;
PATH=%GOROOT%\bin
```

2、获取gocode.exe

> go get -u github.com/nsf/gocode

在GOPATH路径下找到bin目录（F:\GolangProjects\bin）里的 _**gocode.exe**_，复制替换掉liteide安装目录bin下的gocode.exe文件，重新打开liteide就可以了。

