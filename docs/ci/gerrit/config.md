## http的认证文件

* 安装工具包

> yum install -y httpd-tools

* 创建用户、密码

**cd /home/gerrit/gerrit\_site/  **进入存放**认证文件**的目录

**htpasswd -c htpasswd.conf admin**在当前目录创建 _**htpasswd.conf **_文件，并添加一个admin用户并设置密码

```
[gerrit@centos233 gerrit_site]$ htpasswd -c htpasswd.conf admin
New password: 
Re-type new password: 
Adding password for user admin
```

* 新增用户、修改用户密码

> htpasswd -m htpasswd.conf admin

```
[gerrit@centos233 gerrit_site]$ htpasswd -m htpasswd.conf userName
New password: 
Re-type new password: 
Adding password for user userName
```

脚本修改密码

```markdown
#!/usr/bin/expect
set timeout 30
spawn htpasswd -m ./htpasswd.conf [lindex $argv 0]
expect "New password:"
send "[lrange $argv 1 1]\r"
expect "Re-type new password:"
send "[lrange $argv 1 1]\r"
interact
```

* 验证用户密码并修改密码

```markdown
#!/bin/bash
if [ $# -lt 3 ]
then
    echo "Error: param error!!
请输入：指令 username oldPwd newPwd"
exit
fi
salt=$(cat ./htpasswd.conf | grep ^$1: | cut -d$ -f3)
#echo "salt: $salt"
password=$(openssl passwd -apr1 -salt $salt $2)

grep -q $1:$password ./htpasswd.conf

if [ $? -eq 0 ]
then
    echo "password is valid"
    expect ./modify.exp $1 $3
else
    echo "password is invalid"
fi
```

## Nginx代理设置

> _vim /usr/local/nginx/conf/vhost/gerrit.conf_

```markdown
server {
    listen *:8088; //监听的端口
    server_name gerrit.wenbin.com;
    allow   all;
    deny    all;

    auth_basic "Welcomme to Gerrit Code Review Site!";
    auth_basic_user_file /home/gerrit/gerrit_site/htpasswd.conf; //AuthUserFile路径，即http认证文件

    location / {
        proxy_pass  http://127.0.0.1:8081; //代理到本地的8081端口，对应于gerrit的监听端口
                                           //注意后面不能加"/"，否则会出现“Code Review - Error The page you requested was not found....permission to view this page”的报错
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
    }

    error_page  404   /404.html;
    location = /404.html {

    }

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}
```

重启nginx服务

> _/usr/local/nginx/sbin/nginx -s reload_

## 防火墙配置

> _vim /etc/firewalld/zones/public.xml_

```css
<?xml version="1.0" encoding="utf-8"?>
<zone>
  <short>Public</short>
  <description>For use in public areas. You do not trust the other computers on networks to not harm your computer. Only selected incoming connections are accepted.</description>
  <service name="dhcpv6-client"/>
  <service name="ssh"/>
  <service name="http"/>
  <port protocol="tcp" port="80"/>
  <port protocol="tcp" port="8088"/>
  <port protocol="tcp" port="20"/>
  <port protocol="tcp" port="29418"/>
</zone>
```

放开29418和8088端口

