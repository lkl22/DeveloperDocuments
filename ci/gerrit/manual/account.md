#### 添加新的账户（管理员）

1、在认证文件所在的目录，执行下面的指令创建新的用户

```
[root@centos233 gerrit_site]# htpasswd -m htpasswd.conf newUser
New password: 
Re-type new password: 
Adding password for user newUser
```

2、在网页上登录

第一次使用登录的第一个用户为管理员

![](/assets/gerrit/gerrit_login.png)

#### 添加ssh public keys

添加ssh公钥，通过ssh方式 pull或push代码的时候必须添加公钥，客户机生成钥匙对，将公钥添加到代码服务器

![](/assets/gerrit/gerrit_ssh_key_add.png)

#### 注册邮箱

![](/assets/gerrit/gerrit_register_email.png)

![](/assets/gerrit/gerrit_email_verification.png)

#### Group管理（管理员）

* 创建用户组

![](/assets/gerrit/gerrit_group_create.png)

* 管理用户组成员

![](/assets/gerrit/gerrit_group_members.png)

