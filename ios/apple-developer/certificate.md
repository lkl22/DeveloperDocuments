### Introduction

### 开发者账号申请成功后，登录后点击** Certificates, Identifiers & Profiles **进入证书管理界面![](/assets/user/user_certificates.png)

### Certificates

#### Creating a Certificate Signing Request \(CSR\)

In the Applications folder on your Mac, open the Utilities folder and launch **Keychain Access**.

Within the Keychain Access drop down menu, select _**Keychain Access &gt; Certificate Assistant &gt; Request a Certificate from a Certificate Authority.**_

* In the Certificate Information window, enter the following information:
  * In the User Email Address field, enter your **email address**.
  * In the Common Name field, create a name for your **private key** \(e.g., John Doe Dev Key\).
  * The CA Email Address field should be left empty.
  * In the "Request is" group, select the "**Saved to disk**" option.
* Click Continue within Keychain Access to complete the CSR generating process.

#### Add IOS Certificate

**Select Type**：选择需要的证书类型（按需选型）

**Request**：About Creating a Certificate Signing Request \(CSR\)，按指导生成CSR文件

**Generate**：上传生成的CSR文件（测试和发布可以使用同一个CSR文件生成证书），点击**Continue**生成证书

**Download**：点击 **Download **按钮下载证书，双击证书文件添加到 **Keychain **中

### Identifiers

![](/assets/user/user_identifiers.png)

**select services**

![](/assets/user/user_identifiers1.png)

点击 Continue 进入 Confirm yourApp ID 界面，点击Register 按钮完成注册。

### Devices

**Registering a New Device or Multiple Devices**，用于开发调试打包

![](/assets/user/user_devices.png)

### Provisioning Profiles

**Select Type**：选择一个需要的类型

**Configure**：

1、Select App ID：选择前面创建的应用的ID

2、Select certificates：选择一个前面生成的证书（开发对应开发证书、发布对应发布证书）

3、Select devices：选择可以用于该应用调试的设备（Development的需要，Distribution的没有该选项）

**Generate**：输入 _Profile Name_，点击 **Continue **按钮生成profile文件

**Download**：点击 Download 按钮下载profile文件，双击下载的profile文件，就可以在xcode中选择了

### Export the certificate

为了多人合作开发，需要导出证书添加到其他人的电脑的Keychain中，并且将项目的Provisioning Profile一起提供给团队其他人![](/assets/user/user_export_certificate.png)![](/assets/user/user_export_certificate1.png)

