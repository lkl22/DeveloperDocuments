#### 默认安装

```
rpm -i https://gerritforge.com/gerritforge-repo-1-2.noarch.rpm
yum install -y gerrit
```

#### war包安装

* Download

> wget [https://gerrit-releases.storage.googleapis.com/gerrit-2.14.3.war](https://gerrit-releases.storage.googleapis.com/gerrit-2.15-rc2.war)

* 添加user

```
useradd gerrit
cd /home/gerrit/
su gerrit  //切换用户
```

* 创建数据库

```
mysql -u gerrit -p  //使用gerrit用户登录
create database gerritdb default character set utf8 collate utf8_general_ci; //创建数据库
grant all privileges on gerritdb.* to gerrit@'localhost' identified by 'gerrit' with grant option; //修改权限
flush privileges; //刷新权限，使权限修改生效
```

* 指令安装

在war包所在目录下，执行**java -jar gerrit\*.war init -d ~/gerrit\_site**，-d 后跟安装目录

有一些判断性的问题会用`[y/N]`这样的形式，大写的字母表示默认，我们直接敲回车就表示采用默认的安装选项。

```
[gerrit@centos233 ~]$ java -jar gerrit*.war init -d ~/gerrit_site
Using secure store: com.google.gerrit.server.securestore.DefaultSecureStore
[2018-02-08 18:20:49,823] [main] INFO  com.google.gerrit.server.config.GerritServerConfigProvider : No /home/gerrit/gerrit_site/etc/gerrit.config; assuming defaults

*** Gerrit Code Review 2.14.3
*** 

Create '/home/gerrit/gerrit_site' [Y/n]? y

*** Git Repositories
*** 

Location of Git repositories   [git]:  这里一定要写git放的目录，没有的话自己会创建的

*** SQL Database
*** 

Database server type           [h2]: mysql  使用的数据库类型

Gerrit Code Review is not shipped with MySQL Connector/J 5.1.41
**  This library is required for your configuration. **
Download and install it now [Y/n]? y
Downloading https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.41/mysql-connector-java-5.1.41.jar ... OK
Checksum mysql-connector-java-5.1.41.jar OK
Server hostname                [localhost]: 
Server port                    [(mysql default)]: 
Database name                  [reviewdb]: gerritdb
Database username              [gerrit]: 
gerrit's password              : 
              confirm password : 

*** Index
*** 

Type                           [LUCENE/?]:  默认就好，直接回车

*** User Authentication
*** 

Authentication method          [OPENID/?]: http 一定要写http，不然就不是反向代理了，写development_become_any_account就随意登陆了
Get username from custom HTTP header [y/N]? n 一定要n，不然反向代理gerrit报错为缺少一个y的header
SSO logout URL                 : 
Enable signed push support     [y/N]? n

*** Review Labels
*** 

Install Verified label         [y/N]? y  //要搭建CI系统，这里需要选择安装

*** Email Delivery
*** 

SMTP server hostname           [localhost]: smtp.163.com
SMTP server port               [(default)]: 25  25端口是163的smtp
SMTP encryption                [NONE/?]: 
SMTP username                  [gerrit]: xxx@163.com
sz.lkl@163.com's password      : 
              confirm password : 

*** Container Process
*** 

Run as                         [gerrit]:  这是用户，root也可以
Java runtime                   [/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.102-4.b14.el7.x86_64/jre]: 
Copy gerrit-2.14.3.war to /home/gerrit/gerrit_site/bin/gerrit.war [Y/n]? y
Copying gerrit-2.14.3.war to /home/gerrit/gerrit_site/bin/gerrit.war

*** SSH Daemon
*** 

Listen on address              [*]: 
Listen on port                 [29418]: 
Generating SSH host key ... rsa... dsa... ed25519... ecdsa 256... ecdsa 384... ecdsa 521... done

*** HTTP Daemon
*** 

Behind reverse proxy           [y/N]? y
Proxy uses SSL (https://)      [y/N]? n
Subdirectory on proxy server   [/]: 
Listen on address              [*]: 127.0.0.1
Listen on port                 [8081]: 
Canonical URL                  [http://*/]: http://192.168.3.235:8088

*** Cache
*** 


*** Plugins
*** 

Installing plugins.
Install plugin commit-message-length-validator version v2.14.3 [y/N]? y
Installed commit-message-length-validator v2.14.3
Install plugin download-commands version v2.14.3 [y/N]? y
Installed download-commands v2.14.3
Install plugin hooks version v2.14.3 [y/N]? y
Installed hooks v2.14.3
Install plugin replication version v2.14.3 [y/N]? y
Installed replication v2.14.3
Install plugin reviewnotes version v2.14.3 [y/N]? y
Installed reviewnotes v2.14.3
Install plugin singleusergroup version v2.14.3 [y/N]? y
Installed singleusergroup v2.14.3
Initializing plugins.

Initialized /home/gerrit/gerrit_site
Executing /home/gerrit/gerrit_site/bin/gerrit.sh start
Starting Gerrit Code Review: OK
Waiting for server on gerrit.wenbin.com:80 ... OK
Opening http://gerrit.wenbin.com/#/admin/projects/ ...OK
[gerrit@centos233 ~]$
```

安装完成之后，gerrit会自动启动，而且会开始监听两个端口:

1. 29418: 默认的ssh端口；
2. 8080: gerrit默认的web页面端口。

```
[root@centos233 gerrit_site]# netstat -ltpn | grep -i gerrit
tcp6       0      0 :::29418                :::*                    LISTEN      26903/GerritCodeRev 
tcp6       0      0 127.0.0.1:8081          :::*                    LISTEN      26903/GerritCodeRev
```

* 查看配置文件

> _vim gerrit\_site/etc/gerrit.config_

```
[gerrit]
        basePath = git
        serverId = 566ccad4-b987-4bc2-b407-1a78c64e3cc5
        canonicalWebUrl = http://192.168.3.235:8088  //gerrit的主页地址，搭建gerrit所在主机的ip地址及nginx代理端口或者对应的域名
[database]
        type = mysql
        hostname = localhost
        database = gerritdb
        username = gerrit
[index]
        type = LUCENE
[auth]
        type = HTTP
[receive]
        enableSignedPush = false
[sendemail]   //可以不要，会使用系统默认的发送邮件
        smtpServer = smtp.163.com
        smtpServerPort = 25
        smtpUser = xxx@163.com
        smtpPass = xxxx   
        from = CodeReview<xxx@163.com>  
[container]
        user = gerrit
        javaHome = /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.102-4.b14.el7.x86_64/jre
[sshd]
        listenAddress = *:29418  //ssh监听的端口
[httpd]
        listenUrl = proxy-http://127.0.0.1:8081/   //反向代理监听的端口
[cache]
        directory = cache
```



