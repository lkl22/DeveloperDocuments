## Install

> yum -y install gitweb

## Config

> _vim /etc/gitweb.conf_

```markdown
# Set the path to git projects.  This is an absolute filesystem path which will
# be prepended to the project path.
#our $projectroot = "/var/lib/git";
$projectroot = "/home/gerrit/gerrit_site/git";  #插入一行，指定gerrit里git仓库的所在位置
```

## Gerrit配置

> _vim /home/gerrit/gerrit\_site/etc/gerrit.config_

在配置文件末尾加上下面的配置

```markdown
[gitweb]
        type = gitweb
        cgi = /var/www/git/gitweb.cgi
```

## 代理设置

* apache

> _yum -y install httpd_ 安装httpd

> _vim /etc/httpd/conf/httpd.conf_

```markdown
#Listen 12.34.56.78:80
Listen 80 改为
Listen 127.0.0.1:80  //指定apache所占用的IP及端口，避免与nginx端口冲突
```

> _vim /usr/local/nginx/conf/nginx.conf_

```markdown
server {
        #listen       80;               //注释掉，只监听指定ip下的80端口
        listen       192.168.3.235:80;  //指定Nginx只占用某个IP的80端口
        server_name  localhost;
```

> _vim /etc/httpd/conf.d/gitweb.conf_

```markdown
#
# gitweb
#
Alias /gitweb "/var/www/git"
<Directory "/var/www/git">
    Options +ExecCGI
    AddHandler cgi-script .cgi
    DirectoryIndex index.cgi gitweb.cgi
    Order allow,deny
    Allow from all
</Directory>
```

开机自动启动apache代理

> systemctl enable httpd



