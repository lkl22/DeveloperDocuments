# shell教程

* [Shell 变量](#Shell变量)
  * [使用变量](#使用变量)
  * [只读变量](#只读变量)
  * [删除变量](#删除变量)
  * [变量类型](#变量类型)
* [Shell 字符串](#Shell字符串)
  * [单引号](#单引号)
  * [双引号](#双引号)
  * [拼接字符串](#拼接字符串)
  * [获取字符串长度](#获取字符串长度)
  * [提取子字符串](#提取子字符串)
  * [查找子字符串](#查找子字符串)
* [Shell test 命令](#Shelltest命令)
  * [数值测试](#数值测试)
  * [字符串测试](#字符串测试)
  * [文件测试](#文件测试)
* [Linux sed 命令](#Linuxsed命令)
  * [数据的搜寻并替换](#数据的搜寻并替换)
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

## <a name="Shell字符串">Shell 字符串</a>

字符串是shell编程中最常用最有用的数据类型（除了数字和字符串，也没啥其它类型好用了），字符串可以用单引号，也可以用双引号，也可以不用引号。

### <a name="单引号">单引号</a>

> str='this is a string'

单引号字符串的限制：

* 单引号里的任何字符都会原样输出，**单引号字符串中的变量是无效的**；
* 单引号字串中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，作为字符串拼接使用。

### <a name="双引号">双引号</a>
```shell script
your_name='runoob'
str="Hello, I know you are \"$your_name\"! \n"
echo -e $str
```

输出结果为：
```shell script
Hello, I know you are "runoob"! 
```

双引号的优点：

* 双引号里可以有变量
* 双引号里可以出现转义字符

### <a name="拼接字符串">拼接字符串</a>
```shell script
your_name="runoob"
# 使用双引号拼接
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting  $greeting_1
# 使用单引号拼接
greeting_2='hello, '$your_name' !'
greeting_3='hello, ${your_name} !'
echo $greeting_2  $greeting_3
```

输出结果为：
```shell script
hello, runoob ! hello, runoob !
hello, runoob ! hello, ${your_name} !
```

### <a name="获取字符串长度">获取字符串长度</a>
```shell script
string="abcd"
echo ${#string} #输出 4
```

### <a name="提取子字符串">提取子字符串</a>
以下实例从字符串第 2 个字符开始截取 4 个字符：
```shell script
abc:~ likunlun$ string="runoob is a great site"
abc:~ likunlun$ echo ${string:1:4}
unoo
```

> 注意：第一个字符的索引值为 0。

### <a name="查找子字符串">查找子字符串</a>
查找字符 i 或 o 的位置(哪个字母先出现就计算哪个)：
```shell script
string="runoob is a great site"
echo `expr index "$string" io`  # 输出 4
```

> 注意： 以上脚本中 ` 是反引号，而不是单引号 '，不要看错了哦。

## <a name="Shelltest命令">Shell test 命令</a>
Shell中的 test 命令用于检查某个条件是否成立，它可以进行数值、字符和文件三个方面的测试。

### <a name="数值测试">数值测试</a>

|参数	|说明
|---    |---
|-eq	|等于则为真
|-ne	|不等于则为真
|-gt	|大于则为真
|-ge	|大于等于则为真
|-lt	|小于则为真
|-le	|小于等于则为真

```shell script
abc:~ likunlun$ num1=100
abc:~ likunlun$ num2=100
abc:~ likunlun$ if test $[num1] -eq $[num2]
> then
> echo '=='
> else
> echo '!='
> fi
==
```
代码中的 `[]` 执行基本的算数运算，如：
```shell script
#!/bin/bash

a=5
b=6

result=$[a+b] # 注意等号两边不能有空格
echo "result 为： $result"
```

结果为:

> result 为： 11

### <a name="字符串测试">字符串测试</a>
|参数	|说明
|---    |---
|=	    |等于则为真
|!=	    |不相等则为真
|-z 字符串	|字符串的长度为零则为真
|-n 字符串	|字符串的长度不为零则为真

实例

```shell script
num1="ru1noob"
num2="runoob"
if test $num1 = $num2
then
    echo '两个字符串相等!'
else
    echo '两个字符串不相等!'
fi
```

输出结果：

> 两个字符串不相等!

### <a name="文件测试">文件测试</a>

|参数	    |说明
|---        |---
|-e 文件名	|如果文件存在则为真
|-r 文件名	|如果文件存在且可读则为真
|-w 文件名	|如果文件存在且可写则为真
|-x 文件名	|如果文件存在且可执行则为真
|-s 文件名	|如果文件存在且至少有一个字符则为真
|-d 文件名	|如果文件存在且为目录则为真
|-f 文件名	|如果文件存在且为普通文件则为真
|-c 文件名	|如果文件存在且为字符型特殊文件则为真
|-b 文件名	|如果文件存在且为块特殊文件则为真

实例
```shell script
cd /bin
if test -e ./bash
then
    echo '文件已存在!'
else
    echo '文件不存在!'
fi
```

输出结果：

> 文件已存在!

另外，**Shell 还提供了与( -a )、或( -o )、非( ! )三个逻辑操作符用于将测试条件连接起来，其优先级为： ! 最高， -a 次之， -o 最低**。例如：

```shell script
cd /bin
if test -e ./notFile -o -e ./bash
then
    echo '至少有一个文件存在!'
else
    echo '两个文件都不存在'
fi
```

输出结果：

> 至少有一个文件存在!

## <a name="Linuxsed命令">Linux sed 命令</a>

`Linux sed` 命令是利用脚本来处理文本文件。

`sed` 可依照脚本的指令来处理、编辑文本文件。

`sed` 主要用来自动编辑一个或多个文件、简化对文件的反复操作、编写转换程序等。

语法

> sed [-hnV][-e\<script>][-f<script文件>][文本文件]

参数说明：

|参数|说明
|---|---
|-e\<script>或--expression=\<script> |以选项中指定的script来处理输入的文本文件。
|-f<script文件>或--file=<script文件> |以选项中指定的script文件来处理输入的文本文件。
|-h或--help |显示帮助。
|-n或--quiet或--silent |仅显示script处理后的结果。
|-V或--version |显示版本信息。

动作说明：

|动作|说明
|---|---
|a |新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)～
|c |取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
|d |删除，因为是删除啊，所以 d 后面通常不接任何咚咚；
|i |插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)；
|p |打印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行～
|s |取代，可以直接进行取代的工作！通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g 就是啦！

### <a name="数据的搜寻并替换">数据的搜寻并替换</a>

> sed 's/要被取代的字串/新的字串/g'

shell实现trim函数－去除字符串两侧的空格

shell实现trim函数效果去除字符串两侧的空格，以下三个命令等价，都能实现

> sed 's/^\s*//' totrim.txt |sed 's/\s*$//' > trimed.txt
>
> sed 's/^\s*//;s/\s*$//' totrim.txt > trimed.txt
>
> sed -e 's/^\s*//' -e 's/\s*$//' totrim.txt > trimed.txt

主要就是利用正则表达式，^\s*表示字符串前面的零个或多个空格，\s*$表示字符串后面的零个或多个空格。


## <a name="参考文献">参考文献</a>

[Shell 教程 | 菜鸟教程](https://www.runoob.com/linux/linux-shell.html)
