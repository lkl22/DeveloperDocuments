#### 常规使用

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

#### 分支管理

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

_git remote set-url传递两个参数_

1. remote name   例如：origin或者upstream
2. new remote url  例如：git@github.com:USERNAME/OTHERREPOSITORY.git

> git remote set-url origin url

* checkout branch

> git checkout -b localBranch origin/&lt;branch&gt;



