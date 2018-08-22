#### Capability

[http://appium.io/docs/cn/writing-running-appium/caps/index.html](http://appium.io/docs/cn/writing-running-appium/caps/index.html)

* platformName

使用的手机操作系统（iOS、Android或者FirefoxOS）

* deviceName

使用的手机或模拟器类型，iPhone Simulator, iPad Simulator, iPhone Retina 4-inch, Android Emulator, Galaxy S4, 等等.... 在 iOS 上，使用 Instruments 的 instruments -s devices 命令可返回一个有效的设备的列表。在 Andorid 上虽然这个参数目前已被忽略，但仍然需要添加上该参数，可以使用adb devices命令返回一个有效的设备列表。

* app

本地绝对路径\_或\_远程 http URL 所指向的一个安装包（.ipa,.apk,或 .zip 文件）。Appium 将其安装到合适的设备上。请注意，如果您指定了 appPackage 和 appActivity 参数（见下文），Android 则不需要此参数了。该参数也与 browserName 不兼容。

/abs/path/to/my.apk 或 http://myapp.com/app.ipa

* newCommandTimeout

用于客户端在退出或者结束 session 之前，Appium 等待客户端发送一条新命令所花费的时间（秒为单位）

* noReset

在当前 session 下不会重置应用的状态。默认值为 false

**Android独有**

* appPackage

运行的 Android 应用的包名

* appWaitActivity

用于等待启动的 Android Activity 名称

* appWaitDuration

用于等待 appWaitActivity 启动的超时时间（以毫秒为单位）（默认值为 20000\)

* adbPort

用来连接 ADB 服务器的端口（默认值为 5037）

* androidScreenshotPath

在设备中截图被保存的目录名。默认值为 /data/local/tmp

* autoGrantPermissions

让Appium自动确定您的应用需要哪些权限，并在安装时将其授予应用。默认设置为 false



