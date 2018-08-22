#### CentOS 6

* 添加一条规则，生成iptables文件

> iptables -P OUTPUT ACCEPT
>
> service iptables save

* Backup

> mv /etc/sysconfig/iptables /etc/sysconfig/iptables.bak

* Edit

> vim /etc/sysconfig/iptables

```markdown
#vsftpd
-A INPUT -p TCP --dport 61001:62000 -j ACCEPT
-A OUTPUT -p TCP --sport 61001:62000 -j ACCEPT

-A INPUT -p TCP --dport 20 -j ACCEPT
-A OUTPUT -p TCP --sport 20 -j ACCEPT
-A INPUT -p TCP --dport 21 -j ACCEPT
-A OUTPUT -p TCP --sport 21 -j ACCEPT

#这两个一定要放到最后面
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
```

* 重启防火墙

> service iptables restart

#### CentOS 7

* 系统配置目录，目录中存放定义好的网络服务和端口参数，系统参数，不能修改。

_/usr/lib/firewalld/services_

* 用户配置目录

_/etc/firewalld/_

> vim /etc/firewalld/zones/public.xml

自定义添加端口

* 命令的方式添加端口

> firewall-cmd --zone=public --permanent --add-port=8010/tcp

1、firwall-cmd：是Linux提供的操作firewall的一个工具；

2、--permanent：表示设置为持久；

3、--add-port：标识添加的端口；

4、--zone=public：指定的zone为public；

* 服务管理

```
systemctl restart firewalld.service 重启
systemctl start firewalld.service 开启
systemctl stop firewalld.service 关闭
systemctl enable firewalld 开机启动
```

* 查看防火墙状态

```
systemctl status firewall  或者
firewall-cmd --state
```

* 常用命令介绍

```markdown
firewall-cmd --state ##查看防火墙状态，是否是running
firewall-cmd --reload ##重新载入配置，比如添加规则之后，需要执行此命令
firewall-cmd --get-zones ##列出支持的zone
firewall-cmd --get-services ##列出支持的服务，在列表中的服务是放行的
firewall-cmd --query-service ftp ##查看ftp服务是否支持，返回yes或者no
firewall-cmd --add-service=ftp ##临时开放ftp服务
firewall-cmd --add-service=ftp --permanent ##永久开放ftp服务
firewall-cmd --remove-service=ftp --permanent ##永久移除ftp服务
firewall-cmd --add-port=80/tcp --permanent ##永久添加80端口
iptables -L -n ##查看规则，这个命令是和iptables的相同的
man firewall-cmd ##查看帮助
```



