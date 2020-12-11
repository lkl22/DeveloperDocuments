## Centos6

> yum -y install mysql-server

* 启动MariaDB

> service mysqld start

* 停止MariaDB

> service mysqld restart

* 设置Mysql自动启动

> chkconfig mysqld on

* 查看

```
chkconfig --list mysqld
     mysqld 0:off 1:off 2:on 3:on 4:on 5:on 6:off
```

## Centos7

> yum install mariadb-server mariadb

* 启动MariaDB

> systemctl start mariadb

* 停止MariaDB

> systemctl stop mariadb

* 重启MariaDB

> systemctl restart mariadb

* 设置开机启动

> systemctl enable mariadb



