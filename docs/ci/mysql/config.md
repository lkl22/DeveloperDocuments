## 配置字符集

> vim /etc/my.cnf

```markdown
#默认字符集
[mysqld]
default-character-set=utf8
```

## 配置防火墙

外部访问需开放3306端口

> vim /etc/sysconfig/iptables

```
#mysql port
-A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
```

> service iptables restart



