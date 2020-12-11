## Download

[https://tomcat.apache.org/](https://tomcat.apache.org/)

## Unzip

tar -zxvf /developer/apache-tomcat-8.5.16.tar.gz

## Config

> vim conf/server.xml

_在文件中搜索8080端口_

> /8080

_加上**URIEncoding="UTF-8"**_

```bash
<Connector port="8080" protocol="HTTP/1.1"
    connectionTimeout="20000"
    redirectPort="8443" URIEncoding="UTF-8"/>
```



