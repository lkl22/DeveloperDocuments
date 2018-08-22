**选择build方式**

![](/assets/jenkins/jenkins_job_build_choose.png)

可以根据自己的业务需求选择不同的build方式构建自己的工程

#### Invoke Gradle Script![](/assets/jenkins/jenkins_job_build_invoke_gradle.png)

Execute Shell![](/assets/jenkins/jenkins_job_build_execute_shell.png)在command中输入build工程的shell脚本，例如：自动化发布apk到蒲公英平台

wiki：[http://www.pgyer.com/doc/view/jenkins](http://www.pgyer.com/doc/view/jenkins)

```
curl -F "file=@./${Branch}/app/build/outputs/apk/xxxV${VersionName}_Release.apk" -F "uKey=${uKey}" -F "_api_key=${apiKey}" https://qiniu-storage.pgyer.com/apiv1/app/upload
```

#### 



