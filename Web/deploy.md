#### Environment

node

download: [https://nodejs.org/en/download/](https://nodejs.org/en/download/)

```
tar -xvf node-v8.11.3-linux-x64.tar.xz
mv node-v8.11.3-linux-x64 /usr/local/
vim /etc/profile
    export NODE_HOME=/usr/local/node-v8.11.3-linux-x64
    export PATH=$PATH:$NODE_HOME/bin
source /etc/profile
node -v
    v8.11.3

//配置镜像源
npm config set registry https://registry.npm.taobao.org --global
npm config set disturl https://npm.taobao.org/dist --global
```

[Publish Over SSH](http://wiki.jenkins-ci.org/display/JENKINS/Publish+Over+SSH+Plugin): [https://wiki.jenkins.io/display/JENKINS/Publish+Over+SSH+Plugin](https://wiki.jenkins.io/display/JENKINS/Publish+Over+SSH+Plugin)

```
//杀死指定端口的进程
netstat -utlnp|grep 9000|awk '{print $7}'| awk -F '/' '{print "kill "$1}'|sh
//修改文件中的内容
sed "s/192.168.2.251/${ServiceAddress}/g" /var/lib/jenkins/config/url.js > ./url.js
sed "s/9000/${port}/g" iota-fe.conf | sed "s/dist/${port}\/&/g" > ${port}.conf
```



