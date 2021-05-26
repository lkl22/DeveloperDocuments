# Building web apps in WebView

* [Adding a WebView to your app](#AddingaWebViewtoyourapp)
  * [Adding a WebView in the activity layout](#AddingaWebViewintheactivitylayout)
  * [Adding a WebView in onCreate()](#AddingaWebViewinonCreate)
* [Working with WebView on older versions of Android](#WorkingwithWebViewonolderversionsofAndroid)

如果要将Web应用程序（或只是网页）作为客户端应用程序的一部分交付，则可以使用 `WebView` 进行。 `WebView`类是`Android View`类的扩展，允许您将网页显示为活动布局的一部分。 它不包含完全开发的Web浏览器的任何功能，例如导航控件或地址栏。 默认情况下，WebView所做的只是显示一个网页。

使用WebView很有帮助的一种常见情况是，您希望在应用程序中提供可能需要更新的信息，例如最终用户协议或用户指南。 **在您的Android应用程序中，您可以创建一个包含 `WebView` 的 `Activity`，然后使用它来显示在线托管的文档**。

WebView可以提供帮助的另一种情况是，如果您的应用程序向始终需要 `Internet` 连接才能检索数据的用户提供数据，例如电子邮件。 在这种情况下，您可能会发现，在显示带有所有用户数据的网页的Android应用中构建WebView会比执行网络请求然后解析数据并将其呈现在Android布局中更容易。 相反，您可以设计一个针对Android设备定制的网页，然后在加载该网页的Android应用中实现WebView。

## <a name="AddingaWebViewtoyourapp">Adding a WebView to your app<a/>

要将 `WebView` 添加到您的应用程序，可以在活动布局中包含 `<WebView>` 元素，也可以在 `onCreate()` 中将整个“Activity”窗口设置为 `WebView`。

### <a name="AddingaWebViewintheactivitylayout">Adding a WebView in the activity layout<a/>

要将WebView添加到布局中的应用程序，请将以下代码添加到 active 的布局XML文件中：

```xml
<WebView
    android:id="@+id/webview"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
/>
```

要在WebView中加载网页，请使用 `loadUrl()`。 例如：

```java
WebView myWebView = (WebView) findViewById(R.id.webview);
myWebView.loadUrl("http://www.example.com");
```

### <a name="AddingaWebViewinonCreate">Adding a WebView in onCreate()<a/>

要通过 active 的 `onCreate()` 方法将WebView添加到您的应用中，请使用类似于以下内容的逻辑：

```java
WebView myWebView = new WebView(activityContext);
setContentView(myWebView);
```

然后加载页面：

```java
myWebView.loadUrl("https://www.example.com");
```

或从HTML字符串中加载URL：

```java
// Create an unencoded HTML string
// then convert the unencoded HTML string into bytes, encode
// it with Base64, and load the data.
String unencodedHtml =
     "<html><body>'%23' is the percent code for ‘#‘ </body></html>";
String encodedHtml = Base64.encodeToString(unencodedHtml.getBytes(),
        Base64.NO_PADDING);
myWebView.loadData(encodedHtml, "text/html", "base64");
```

> 注意：此HTML可以执行的操作受到限制。 有关编码选项的更多信息，请参见 [loadData()](https://developer.android.google.cn/reference/android/webkit/WebView#loadData(java.lang.String,%20java.lang.String,%20java.lang.String)) 和 [loadDataWithBaseURL()](https://developer.android.google.cn/reference/android/webkit/WebView#loadDataWithBaseURL(java.lang.String,%20java.lang.String,%20java.lang.String,%20java.lang.String,%20java.lang.String)。

但是，在此之前，您的应用必须能够访问 `Internet`。 要获得 `Internet` 访问，请在清单文件中请求 `INTERNET` 权限。 例如：

```xml
<manifest ... >
    <uses-permission android:name="android.permission.INTERNET" />
    ...
</manifest>
```

这就是显示网页的基本WebView所需要的。 此外，您可以通过修改以下内容来自定义 `WebView`：

* 启用 [WebChromeClient](https://developer.android.google.cn/reference/android/webkit/WebChromeClient) 的全屏支持。 当WebView需要更改主机应用程序UI的权限时，例如创建或关闭窗口以及向用户发送 `JavaScript` 对话框，也将调用此类。 要了解有关在这种情况下进行调试的更多信息，请阅读[调试Web应用程序](https://developer.android.google.cn/guide/webapps/debugging)。
* 处理影响内容呈现的事件，例如表单提交错误或使用 [WebViewClient](https://developer.android.google.cn/reference/android/webkit/WebViewClient) 导航。 您也可以使用此子类来拦截URL加载。
* 通过修改 [WebSettings](https://developer.android.google.cn/reference/android/webkit/WebSettings) 启用 `JavaScript`。
* 使用 `JavaScript` 访问已注入 `WebView` 的Android框架对象。

## <a name="WorkingwithWebViewonolderversionsofAndroid">Working with WebView on older versions of Android<a/>

为了在运行您的应用程序的设备上安全地使用最新的 `WebView` 功能，请添加 `AndroidX Webkit`。 `androidx.webkit` 库是一个静态库，您可以将其添加到应用程序中，以使用旧平台版本不可用的 `android.webkit API`。


