#### 1、安装 CodePush CLI

> npm install -g code-push-cli

#### 2、注册CodePush 账号

> code-push register

#### 会跳转授权网页。在这个网页可以选择Github或者微软作为授权提供者，授权完成后，CodePush会显示你的Access Key，复制输入到终端即可完成注册并登陆。_**code-push logout**_ 退出登录。![](/assets/ReactNative/code_push_register.png)3、在CodePush服务器中创建App

> code-push app add &lt;appName&gt; &lt;os&gt; &lt;platform&gt;

注册完成之后会返回一套deployment key，包括Staging和Production

![](/assets/ReactNative/code_push_add_app.png)

> code-push deployment ls &lt;appName&gt; -k

查看部署的key

#### 4、发布更新到CodePush

> code-push release-react &lt;appName&gt; &lt;platform&gt; \[options\]

-t 指定目标的apk版本，build.gradle中配置的 versionName，CodePush要求是三位的



