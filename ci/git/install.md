#### **Download**

[https://github.com/git/git/releases](https://github.com/git/git/releases)

* 下载

> wget https://github.com/git/git/archive/v2.14.0.tar.gz

* 解压

> tar -zxvf git-v2.14.0.tar.gz

#### **Install**

* 安装依赖包

> yum -y install zlib-devel openssl-devel cpio expat-devel gettext-devel curl-devel perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker

* 安装

```
cd git-2.14.0/
make prefix=/usr/local all
make prefix=/usr/local install
```

#### check

> git --version



