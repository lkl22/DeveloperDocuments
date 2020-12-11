#### 启动app的Activity

> adb shell am start -n 包名/Activity全名

#### 查看当前运行的包名和Activity

> adb shell dumpsys window \| findstr mCurrentFocus

#### 向设备输入按键

> adb shell input keyevent KEYCODE\_BACK
>
> adb shell input keyevent 4

#### 本机从设备复制文件

> adb pull 设备文件路径 本机文件路径

#### 本机向设备复制文件

> adb push 本机文件路径 设备文件路径



