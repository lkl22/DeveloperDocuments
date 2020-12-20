## 常规使用

* 克隆代码

> git clone url

* 初始化

> git init

* 查看状态

> git status

* 更新代码

> git pull

* 添加到版本库

> git add .

* 提交代码到本地仓库

> git commit -am 'message'

* 提交代码到远程仓库

```
git push -u origin branch   //branch对应的分支
git push -u -f origin branch //强制提交，覆盖
```

* git 获取最近一次提交的commit id

> git rev-parse HEAD
>
> git rev-parse --short HEAD

```shell script
abc:DeveloperDocuments likunlun$ git rev-parse HEAD
22fe3a63e6264cf846e2ee597c8c9fe230d55fca
abc:DeveloperDocuments likunlun$ git rev-parse --short HEAD
22fe3a6
```

* 根据commitId查看某次提交的内容

> git show commitId

```shell script
abc:DeveloperDocuments likunlun$ git show 22fe3a63e6264cf846e2ee597c8c9fe230d55fca
commit 22fe3a63e6264cf846e2ee597c8c9fe230d55fca (HEAD -> master, origin/master, origin/HEAD)
Author: likunlun <sz.lkl@163.com>
Date:   Sat Dec 12 10:43:23 2020 +0800

    sync android study

diff --git a/AndroidStudy/.gitignore b/AndroidStudy/.gitignore
new file mode 100644
index 0000000..4f7b373
--- /dev/null
+++ b/AndroidStudy/.gitignore
@@ -0,0 +1,9 @@
:
```

## 分支管理

* 查看分支

```
git branch
git branch -r //查看远程
```

* 添加远程分支

> git remote add origin git@git.oschina.net:xxx.git

* 本地分支与远程分支建立联系

> git branch --set-upstream-to=origin/&lt;branch&gt; &lt;localbranch&gt;

* 移除远程分支

> git remote rm origin

* 修改remote URL

`git remote set-url`传递两个参数

1. remote name   例如：origin或者upstream
2. new remote url  例如：git@github.com:USERNAME/OTHERREPOSITORY.git

> git remote set-url origin url

* checkout branch

> git checkout -b localBranch origin/&lt;branch&gt;



