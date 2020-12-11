## Install

官网：[https://jenkins.io/doc/book/installing/](https://jenkins.io/doc/book/installing/)

安装包：[https://pkg.jenkins.io/](https://pkg.jenkins.io/)

根据操作系统选择不同的pkg，这里选择的是[https://pkg.jenkins.io/redhat/](https://pkg.jenkins.io/redhat/)

```
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

yum install jenkins

或者
下载rpm安装包，使用rpm安装
rpm -ivh jenkins-2.7.4-1.1.noarch.rpm
```

This package installation will:

* Setup Jenkins as a daemon launched on start. See`/etc/init.d/jenkins`for more details.

* Create a`jenkins`user to run this service. Home -&gt; /var/lib/jenkins

* Direct console log output to the file`/var/log/jenkins/jenkins.log`. Check this file if you are troubleshooting Jenkins.

* Populate`/etc/default/jenkins`with configuration parameters for the launch, e.g`JENKINS_HOME`

* Set Jenkins to listen on port 8080. Access this port with your browser to start configuration.

## Update

下载最新的jar包替换到旧的jar后，重启即可

```
[root@centos233 jenkins]# ls /usr/lib/jenkins/
jenkins.war
```

### 启动服务

> systemctl start jenkins

### 重启服务

> systemctl restart jenkins

### 开机启动

> chkconfig jenkins on

### 查看状态

> _ps -aux \|grep jenkins_

```
[root@centos233 ~]# ps -aux | grep jenkins
jenkins   3819  259  4.1 7448568 329332 ?      Ssl  10:02   0:25 /etc/alternatives/java -Dcom.sun.akuma.Daemon=daemonized -Djava.awt.headless=true -DJENKINS_HOME=/var/lib/jenkins -jar /usr/lib/jenkins/jenkins.war --logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war --daemon --httpPort=8089 --debug=5 --handlerCountMax=100 --handlerCountMaxIdle=20
root      3895  0.0  0.0 112668   968 pts/0    S+   10:02   0:00 grep --color=auto jenkins
```



