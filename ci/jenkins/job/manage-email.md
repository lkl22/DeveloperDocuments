### 一、Jenkins内置默认的邮件通知配置

1、全局配置

**Jenkins -&gt; Manage Jenkins -&gt; Configure System**

系统管理员的邮箱配置![](/assets/jenkins/jenkins_email_admin_address.png)邮件通知项，填入SMTP服务器信息及用户名、密码等认证信息。

![](/assets/jenkins/jenkins_global_email_notification.png)

在测试接收邮箱会收到由Jenkins系统管理员的邮箱发出来的一封测试邮件。说明邮箱通知确实已经配置正确并能够正常收发

Jenkins的通知邮件了。

2、项目配置

在项目的设置中找到“增加构建后的操作步骤”/"Add post-build Actions"，选择“_**E-mail Notifacation**_”通过E-mail通知。![](/assets/jenkins/jenkins_post_build_email_notification.png)如果配置没有问题，在构建出问题的时候都会有邮件通知到邮件通知接收者。

### 二、Email Extension Plugin插件配置邮件通知

参考：[http://blog.csdn.net/fullbug/article/details/53024562](http://blog.csdn.net/fullbug/article/details/53024562)

1、全局配置

**Jenkins -&gt; Manage Jenkins -&gt; Configure System**![](/assets/jenkins/jenkins_global_ext_email_notification.png)点击最右下角的"Default Triggers ..."按钮设置默认的触发邮件通知的事件。

![](/assets/jenkins/jenkins_global_ext_email_default_triggers.png)

设置Default Content

参考：[http://www.cnblogs.com/luolizhi/p/5583296.html](http://www.cnblogs.com/luolizhi/p/5583296.html)

```markdown
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${PROJECT_NAME}-第${BUILD_NUMBER}次构建日志</title>
</head>

<body leftmargin="8" marginwidth="0" topmargin="8" marginheight="4"
    offset="0">
    <table width="95%" cellpadding="0" cellspacing="0"
        style="font-size: 11pt; font-family: Tahoma, Arial, Helvetica, sans-serif">
        <tr>
            <td>(本邮件是程序自动下发的，请勿回复！)</td>
        </tr>
        <tr>
            <td><h2>
                    <font color="#0000FF">构建结果 - ${BUILD_STATUS}</font>
                </h2></td>
        </tr>
        <tr>
            <td><br />
            <b><font color="#0B610B">构建信息</font></b>
            <hr size="2" width="100%" align="center" /></td>
        </tr>
        <tr>
            <td>
                <ul>
                    <li>项目名称&nbsp;：&nbsp;${PROJECT_NAME}</li>
                    <li>构建编号&nbsp;：&nbsp;第${BUILD_NUMBER}次构建</li>
                    <li>触发原因：&nbsp;${CAUSE}</li>
                    <li>构建日志：&nbsp;<a href="${BUILD_URL}console">${BUILD_URL}console</a></li>
                    <li>构建&nbsp;&nbsp;Url&nbsp;：&nbsp;<a href="${BUILD_URL}">${BUILD_URL}</a></li>
                    <li>工作目录&nbsp;：&nbsp;<a href="${PROJECT_URL}ws">${PROJECT_URL}ws</a></li>
                    <li>项目&nbsp;&nbsp;Url&nbsp;：&nbsp;<a href="${PROJECT_URL}">${PROJECT_URL}</a></li>
                </ul>
            </td>
        </tr>
        <tr>
            <td><b><font color="#0B610B">Changes Since Last
                        Successful Build:</font></b>
            <hr size="2" width="100%" align="center" /></td>
        </tr>
        <tr>
            <td>
                <ul>
                    <li>历史变更记录 : <a href="${PROJECT_URL}changes">${PROJECT_URL}changes</a></li>
                </ul> ${CHANGES_SINCE_LAST_SUCCESS,reverse=true, format="Changes for Build #%n:<br />%c<br />",showPaths=true,changesFormat="<pre>[%a]<br />%m</pre>",pathFormat="&nbsp;&nbsp;&nbsp;&nbsp;%p"}
            </td>
        </tr>
        <tr>
            <td><b>Test Informations</b>
            <hr size="2" width="100%" align="center" /></td>
        </tr>
        <tr>
            <td><pre
                    style="font-size: 11pt; font-family: Tahoma, Arial, Helvetica, sans-serif">Total:${TEST_COUNTS,var="total"},Pass:${TEST_COUNTS,var="pass"},Failed:${TEST_COUNTS,var="fail"},Skiped:${TEST_COUNTS,var="skip"}</pre>
                <br /></td>
        </tr>
        <tr>
            <td><b><font color="#0B610B">构建日志 (最后 100行):</font></b>
            <hr size="2" width="100%" align="center" /></td>
        </tr>
        <tr>
            <td><textarea cols="80" rows="30" readonly="readonly"
                    style="font-family: Courier New">${BUILD_LOG, maxLines=100}</textarea>
            </td>
        </tr>
    </table>
</body>
</html>
```

2、项目配置

在项目的设置中找到“增加构建后的操作步骤”/"Add post-build Actions"，选择“_**Editable Email Notifacation**_”通过E-mail通知。

在设置中保存默认就可以了，可以在“_**Advanced Settings**_”中针对该项目进行个性化的配置。

![](/assets/jenkins/jenkins_post_build_ext_email_notification.jpg)

通过测试工程构建后，Jenkins配置的邮件通接收人可以正常收到构建信息的邮件通知。![](/assets/jenkins/jenkins_ext_email_content.png)

