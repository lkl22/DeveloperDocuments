#### Install

[https://github.com/NetEase/Emmagee/releases](https://github.com/NetEase/Emmagee/releases)

下载apk安装到Android设备上

#### Use

1、配置设置项，采集频率、浮窗显示...

![](/assets/Emmagee/emmagee_setting.png)

2、启动Emmagee，列表中会默认加载手机安装的所有应用

3、选择你需要测试的应用，点击“开始测试”，被测应用会被启动

4、测试完成后回到Emmagee界面，点击“结束测试”，测试结果会保存在手机指定目录的CSV文件中

5、使用指令导出CSV文件

> adb pull /sdcard/Emmagee/ F:\Emmagee\

![](/assets/Emmagee/emmagee_result.png)

6、将csv数据拷贝到excel中生成图表，使用自带的统计图标功能生成统计图，即可清晰看到整个操作过程中cpu、内存等关键数据的变化。

