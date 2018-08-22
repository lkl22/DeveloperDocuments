#### Install

> yum install tcl tcl-devel
>
> yum install expect expect-devel

#### Expect用法

* 告诉操作系统脚本里的代码使用那一个shell来执行

> \#!/usr/bin/expect

* 设置超时时间（单位：秒   timeout -1 为永不超时）

> set timeout 30

* 给shell运行进程加个壳，用来传递交互指令（expect内部命令），执行其他的shell指令

> spawn ssh -l username 192.168.1.1

* 判断上次输出结果里是否包含“password:”的字符串，如果有则立即返回，否则就等待一段时间后返回，这里等待时长就是前面设置的30秒 

> expect "password:"

* 执行交互动作，与手工输入密码的动作等效

> send "ispass\r"   命令字符串结尾别忘记加上“\r”，如果出现异常等待的状态可以核查一下。

* 执行完成后保持交互状态，把控制权交给控制台，这个时候就可以手工操作了。如果没有这一句登录完成后会退出，而不是留在远程终端上。

> interact

* expect脚本可以接受从bash传递过来的参数.可以使用\[lindex $argv n\]获得，n从0开始，分别表示第一个,第二个,第三个....参数

> $argv 参数数组



