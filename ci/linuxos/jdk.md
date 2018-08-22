#### Download

[http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

#### Uninstall

yum remove \*\*

#### Install

rpm -ivh /developer/jdk-8u144-linux-x64.rpm

#### Config

> vim /etc/profile

在文件末尾添加

```
export JAVA_HOME=/usr/java/jdk1.8.0_144
export MAVEN_HOME=/developer/apache-maven-3.5.0
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
```

使配置失效

> source /etc/profile

Check

> java -version



