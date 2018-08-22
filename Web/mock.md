RAP：[https://github.com/thx/rap2-delos](https://github.com/thx/rap2-delos)

#### Redis

[https://redis.io](https://redis.io)

```
//安装
$ wget http://download.redis.io/releases/redis-4.0.10.tar.gz
$ tar xzf redis-4.0.10.tar.gz
$ cd redis-4.0.10
$ make

//配置
vim /etc/profile
    //后台启动Redis服务指令
    alias redis-server='nohup /developer/software/redis-4.0.10/src/redis-server &'
    //Redis客户端运行指令
    alias redis-cli='/developer/software/redis-4.0.10/src/redis-cli'

source /etc/profile
//启动
$ redis-server
//测试
$ redis-cli
redis> set foo bar
OK
redis> get foo
"bar"
```

#### rap2-delos

后端数据API服务器，基于Koa + MySQL：[https://github.com/thx/rap2-delos](https://github.com/thx/rap2-delos)

#### rap2-dolores

前端静态资源，基于React：[https://github.com/thx/rap2-dolores](https://github.com/thx/rap2-dolores)

#### Issues

Error: EACCES: permission denied, mkdir '/root/rap2-dolores-master/node\_modules/node-sass/.node-gyp'

[https://github.com/sass/node-sass/blob/master/TROUBLESHOOTING.md\#installing-node-sass-4x-with-node--4](https://github.com/sass/node-sass/blob/master/TROUBLESHOOTING.md#installing-node-sass-4x-with-node--4)

```
Linux
This can happen if you are install node-sass as root, or globally with sudo. This is a security feature of npm. You should always avoid running npm as sudo because install scripts can be unintentionally malicious. Please check npm documentation on fixing permissions.

If you must however, you can work around this error by using the --unsafe-perm flag with npm install i.e.

$ sudo npm install --unsafe-perm -g node-sass
If this didn't solve your problem please open an issue with the output from our debugging script.
```

[How to Prevent Permissions Errors](https://docs.npmjs.com/getting-started/fixing-npm-permissions)

##### Change npm's Default Directory

To minimize the chance of permissions errors, you can configure npm to use a different directory. In this example, it will be a hidden directory on your home folder.

1. Back-up your computer before you start.

2. Make a directory for global installations:

   ```
    mkdir ~/.npm-global

   ```

3. Configure npm to use the new directory path:

   ```
    npm config set prefix '~/.npm-global'

   ```

4. Open or create a`~/.profile`file and add this line:

   ```
    export PATH=~/.npm-global/bin:$PATH

   ```

5. Back on the command line, update your system variables:

   ```
    source ~/.profile

   ```

Test: Download a package globally without using`sudo`.

```
    npm install -g jshint

```

Instead of steps 2-4, you can use the corresponding ENV variable \(e.g. if you don't want to modify`~/.profile`\):

```
    NPM_CONFIG_PREFIX=~/.npm-global
```



