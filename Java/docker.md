[https://www.docker.com/](https://www.docker.com/)

---

### CentOS Docker 安装

```markdown
# 查看系统内核是否满足
[root@centos233 etc]# uname -r 
3.10.0-514.el7.x86_64

# 移除旧的版本
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

# 安装一些必要的系统工具
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# 添加软件源信息
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 更新 yum 缓存
sudo yum makecache fast

# 安装 Docker-ce
sudo yum -y install docker-ce

# 启动 Docker 后台服务
sudo systemctl start docker
```

**测试运行 hello-world**

```markdown
[root@centos233 yum.repos.d]# docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
9db2ca6ccae0: Pull complete 
Digest: sha256:4b8ff392a12ed9ea17784bd3c9a8b1fa3299cac44aca35a85c90c5e3c7afacdc
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/
```

由于本地没有hello-world这个镜像，所以会下载一个hello-world的镜像，并在容器内运行。

### 删除 Docker CE

```
sudo yum remove docker-ce
sudo rm -rf /var/lib/docker
```



