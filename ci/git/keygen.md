# 生成公钥

大多数 Git 服务器都会选择使用 SSH 公钥来进行授权。系统中的每个用户都必须提供一个公钥用于授权，没有的话就要生成一个。生成公钥的过程在所有操作系统上都差不多。 首先先确认一下是否已经有一个公钥了。SSH 公钥默认储存在账户的主目录下的\`**~/.ssh**\`目录

```
$ cd ~/.ssh
$ ls
authorized_keys2  id_dsa       known_hosts
config            id_dsa.pub
```

关键是看有没有用\`something\`和\`something.pub\`来命名的一对文件，这个\`something\`通常就是\`**id\_dsa**\`或\`**id\_rsa**\`。有\`**.pub**\`后缀的文件就是公钥，另一个文件则是密钥。假如没有这些文件，或者干脆连\`**.ssh**\`目录都没有，可以用\`**ssh-keygen**\`来创建。

```
$ ssh-keygen -t rsa -C "邮箱地址"
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/schacon/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/schacon/.ssh/id_rsa.
Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
The key fingerprint is:
43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local
```

它先要求你确认保存公钥的位置（\`**.ssh/id\_rsa**\`），然后它会让你重复一个密码两次，如果不想在使用公钥的时候输入密码，可以留空。

显示公钥内容，复制给Git服务器的管理员

```
$ cat ~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
NrRFi9wrf+M7Q==邮箱地址
```

使用**ssh-add**命令可以把私钥添加到**ssh-agent**，当登录远程主机中的程序\(如:git push\)请求对应的私钥时，可以由ssh-agent把本地私钥发送给远程主机\(启动这个功能要在ssh配置中设置\`ForwardAgent yes\`\)

> _ssh-add ~/.ssh/id\_rsa_

    _Could not open a connection to your authentication agent._

    eval \`ssh-agent\`

    ssh-add ~/.ssh/id\_rsa



