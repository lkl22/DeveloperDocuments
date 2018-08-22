* 启动

> /home/gerrit/gerrit\_site/bin/gerrit.sh start

* 停止

> /home/gerrit/gerrit\_site/bin/gerrit.sh stop

* 重启

> /home/gerrit/gerrit\_site/bin/gerrit.sh restart

* 查看状态

> _netstat -ltpn \| grep -i gerrit_

```
[root@centos233 ~]# netstat -ltpn | grep -i gerrit
tcp6       0      0 :::29418                :::*                    LISTEN      3427/GerritCodeRevi 
tcp6       0      0 127.0.0.1:8081          :::*                    LISTEN      3427/GerritCodeRevi
```

* 开机自动启动

> sudo ln -snf /home/gerrit/gerrit\_site/bin/gerrit.sh /etc/init.d/gerrit.sh

服务自动启动脚本/etc/init.d/gerrit.sh需要通过/etc/default/gerritcodereview\(该申明被卸载gerrit.sh脚本里面\)文件来提供一些配置。

> _vim /etc/default/gerritcodereview_

```
GERRIT_SITE=/home/gerrit/gerrit_site
NO_START=0
```

> _vim /etc/rc.d/rc.local_

```markdown
# that this script will be executed during boot.

touch /var/lock/subsys/local
/etc/init.d/gerrit.sh start   //gerrit启动命令
```

_**chmod a+x /etc/rc.d/rc.local **_**修改文件的可执行权限，不然不生效**



