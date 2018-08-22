#### **用户管理**

* root用户登录

```
mysql -u root
mysql -u root -p //使用密码登录
```

* 添加一个用户

> insert into mysql.user\(Host,User,Password\) values\("localhost","userName",password\("pwd"\)\);

* 删除匿名用户

> delete from mysql.user where user='';

* 设置密码

```
set password for root@localhost=password('root');
set password for root@127.0.0.1=password('root');
```

* 查看用户表

> select user,host,password from mysql.user;

_\G代表格式化_

> select \* from mysql.user\G;

#### **权限管理**

* 修改数据库权限

> grant all privileges on databaseName.\* to userName@'%' identified by 'password' with grant option;

* 刷新权限，使修改生效

> flush privileges;

* 查看授权

> SHOW GRANTS FOR 'userName'@'localhost';

#### 数据库管理

* 显示数据库

> show databases;

* 使用数据库

> use databaseName

* 创建数据库databaseName

> create database databaseName default character set utf8 collate utf8\_general\_ci;

* 删除数据库

> drop database 'databaseName';

#### 表格管理

* 显示数据库中的所有数据表

> show tables;

* 应用数据库脚本，mmall.sql中都是操作表的sql语句

> source /developer/config/mmall.sql;

* 插入数据

> insert into TableName\(FieldName1,FieldName2,FieldName3...\) values\("value1","value2","value3"...\);

* 更新数据

> update TableName set FieldName=value where FieldName like '%xxx';

* 删除数据

> delete from TableName where ...;

* 查询数据

> select \* from TableName where ... order by FieldName;



