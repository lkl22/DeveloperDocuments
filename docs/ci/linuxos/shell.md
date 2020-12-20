# shell教程

* [Shell 变量](#Shell变量)
  * [使用变量](#使用变量)
  * [只读变量](#只读变量)
  * [删除变量](#删除变量)
  * [变量类型](#变量类型)
* [参考文献](#参考文献)

## <a name="Shell变量">Shell 变量</a>

定义变量时，变量名不加美元符号（$，PHP语言中变量需要），如：

> your_name="runoob.com"

**注意，变量名和等号之间不能有空格**。同时，变量名的命名须遵循如下规则：

* 命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。
* 中间不能有空格，可以使用下划线（_）。
* 不能使用标点符号。
* 不能使用bash里的关键字（可用help命令查看保留关键字）。

除了显式地直接赋值，还可以用语句给变量赋值，如：

> for file in \`ls /etc\`
> 
> for file in $(ls /etc)

以上语句将 `/etc` 下目录的文件名循环出来。

### <a name="使用变量">使用变量</a>
使用一个定义过的变量，只要在**变量名前面加美元符号**即可，如：

> your_name="qinjx"
>
> echo $your_name
>
> echo ${your_name}

**变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界**，比如下面这种情况：
```shell script
for skill in Ada Coffe Action Java; do
    echo "I am good at ${skill}Script"
done
```

如果不给skill变量加花括号，写成`echo "I am good at $skillScript"`，解释器就会把`$skillScript`当成一个变量（其值为空），代码执行结果就不是我们期望的样子了。

> 推荐给所有变量加上花括号，这是个好的编程习惯。

已定义的变量，可以被重新定义，如：
```shell script
your_name="tom"
echo $your_name
your_name="alibaba"
echo $your_name
```
这样写是合法的，但注意，第二次赋值的时候不能写$your_name="alibaba"，使用变量的时候才加美元符（$）。

### <a name="只读变量">只读变量</a>
使用 `readonly` 命令可以将变量定义为只读变量，只读变量的值不能被改变。

下面的例子尝试更改只读变量，结果报错：
```shell script
#!/bin/bash
myUrl="https://www.google.com"
readonly myUrl
myUrl="https://www.runoob.com"
```
运行脚本，结果如下：
```shell script
/bin/sh: NAME: This variable is read only.
```

### <a name="删除变量">删除变量</a>
使用 `unset` 命令可以删除变量。语法：

> unset variable_name

变量被删除后不能再次使用。unset 命令不能删除只读变量。

实例
```shell script
#!/bin/sh
myUrl="https://www.runoob.com"
unset myUrl
echo $myUrl
```

以上实例执行将没有任何输出。

### <a name="变量类型">变量类型</a>
运行shell时，会同时存在三种变量：

1. **局部变量** 局部变量在脚本或命令中定义，仅在当前shell实例中有效，其他shell启动的程序不能访问局部变量。
2. **环境变量** 所有的程序，包括shell启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量。
3. **shell变量** shell变量是由shell程序设置的特殊变量。shell变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了shell的正常运行

## <a name="参考文献">参考文献</a>

[Shell 教程 | 菜鸟教程](https://www.runoob.com/linux/linux-shell.html)
