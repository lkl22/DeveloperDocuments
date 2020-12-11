## 开机自动启动

> _vim /etc/init.d/nginx_ 添加以下网址中的脚本

[https://www.nginx.com/resources/wiki/start/topics/examples/redhatnginxinit/](https://www.nginx.com/resources/wiki/start/topics/examples/redhatnginxinit/)

* _nginx=”/usr/sbin/nginx” 修改成nginx执行程序的路径。_

* _NGINX\_CONF\_FILE=”/etc/nginx/nginx.conf” 修改成配置文件的路径_

修改权限

> chmod a+x /etc/init.d/nginx
>
> chkconfig nginx on

## 防火墙配置

nginx防火墙 80端口

> -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT

## 配置nginx

```
cd /usr/local/nginx/conf/
mkdir vhost
vim nginx.conf
    引用配置文件，加在nginx.conf文件后面
    include vhost/*.conf;
```

## 重启

> /usr/local/nginx/sbin/nginx -s reload

nginx: \[error\] open\(\) "/usr/local/nginx/logs/nginx.pid" failed \(2: No such file or directory\)

**使用nginx -c的参数指定nginx.conf文件的位置**

> /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf



