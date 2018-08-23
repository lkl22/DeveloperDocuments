### Windows Android

#### 安装依赖

**Node, Python2, JDK**。注意 Node 的版本必须高于** 8.3**，Python 的版本必须为** 2.x**（不支持 3.x），而 JDK 的版本必须是** 1.8**（不支持 1.9）。

#### Yarn、React Native 的命令行工具（react-native-cli）

[Yarn](http://yarnpkg.com/)是 Facebook 提供的替代 npm 的工具，可以加速 node 模块的下载。React Native 的命令行工具用于执行创建、初始化、更新项目、运行打包服务（packager）等任务。

```markdown
npm install -g yarn react-native-cli
# 安装完 yarn 后同理也要设置镜像源
yarn config set registry https://registry.npm.taobao.org --global
yarn config set disturl https://npm.taobao.org/dist --global
```

安装完 yarn 之后就可以用 yarn 代替 npm 了，例如用**yarn**代替**npm install**命令，用** **_**yarn add 某第三方库名**_** **代替 _**npm install --save 某第三方库名。**_

#### 配置 ANDROID\_HOME 环境变量

React Native 需要通过环境变量来了解你的 Android SDK 装在什么路径，从而正常进行编译。

打开`控制面板`-&gt;`系统和安全`-&gt;`系统`-&gt;`高级系统设置`-&gt;`高级`-&gt;`环境变量`-&gt;`新建`，创建一个名为`ANDROID_HOME`的环境变量（系统或用户变量均可），指向你的 Android SDK 所在的目录。

#### 创建新项目

使用 React Native 命令行工具来创建一个名为"AwesomeProject"的新项目：

```bash
react-native init AwesomeProject
```

**提示：**你可以使用`--version`参数（注意是**两**个杠）创建指定版本的项目。例如`react-native init MyApp --version 0.44.3`。注意版本号必须精确到两个小数点。

#### 编译并运行 React Native 应用

确保你先运行了模拟器或者连接了真机，然后在你的项目目录中运行`react-native run-android`：

```bash
cd AwesomeProject
react-native run-android
```



