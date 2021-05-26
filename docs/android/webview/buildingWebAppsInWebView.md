# Building web apps in WebView

* [Adding a WebView to your app](#AddingaWebViewtoyourapp)
  * [Adding a WebView in the activity layout](#AddingaWebViewintheactivitylayout)
  * [Adding a WebView in onCreate()](#AddingaWebViewinonCreate)
* [Working with WebView on older versions of Android](#WorkingwithWebViewonolderversionsofAndroid)
* [Using JavaScript in WebView](#UsingJavaScriptinWebView)
  * [Enabling JavaScript](#EnablingJavaScript)
  * [Binding JavaScript code to Android code](#BindingJavaScriptcodetoAndroidcode)

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

## <a name="UsingJavaScriptinWebView">Using JavaScript in WebView<a/>

如果您打算在 `WebView` 中加载的网页使用 `JavaScript`，则必须为 `WebView` 启用 `JavaScript`。 启用 `JavaScript` 后，您还可以在应用程序代码和 `JavaScript` 代码之间创建接口。

### <a name="EnablingJavaScript">Enabling JavaScript<a/>

默认情况下，`WebView` 中禁用了 `JavaScript`。 您可以通过附加到 `WebView` 的 `WebSettings` 启用它。可以使用 `getSettings()` 检索 `WebSettings`，然后使用 `setJavaScriptEnabled()` 启用 `JavaScript`。

例如：

```java
WebView myWebView = (WebView) findViewById(R.id.webview);
WebSettings webSettings = myWebView.getSettings();
webSettings.setJavaScriptEnabled(true);
```

`WebSettings` 提供对您可能会有用的其他各种设置的访问。 例如，如果您要开发专门为Android应用程序中的WebView设计的Web应用程序，则可以使用 `setUserAgentString()` 定义自定义用户代理字符串，然后在网页中查询该自定义用户代理以验证 请求您的网页的客户端实际上是您的Android应用。

### <a name="BindingJavaScriptcodetoAndroidcode">Binding JavaScript code to Android code<a/>

在开发专门为 `Android` 应用程序中的 `WebView` 设计的Web应用程序时，可以在 `JavaScript` 代码和客户端 `Android` 代码之间创建接口。 例如，您的 `JavaScript` 代码可以调用 `Android` 代码中的方法来显示对话框，而不是使用 `JavaScript` 的 `alert()` 函数。

要在 `JavaScript` 和 `Android` 代码之间绑定新接口，请调用 `addJavascriptInterface()`，并向其传递要绑定到 `JavaScript` 的类实例以及 `JavaScript` 可以调用以访问该类的接口名称。

例如，您可以在 `Android` 应用程序中包括以下类：

```java
public class WebAppInterface {
    Context mContext;

    /** Instantiate the interface and set the context */
    WebAppInterface(Context c) {
        mContext = c;
    }

    /** Show a toast from the web page */
    @JavascriptInterface
    public void showToast(String toast) {
        Toast.makeText(mContext, toast, Toast.LENGTH_SHORT).show();
    }
}
```

> 警告：如果将 `targetSdkVersion` 设置为17或更高，则必须将 `@JavascriptInterface` 注解添加到 `JavaScript` 希望使用的任何方法，并且该**方法必须是公共的**。 如果不提供注解，则在Android 4.2或更高版本上运行时，您的网页无法访问该方法。

在此示例中，`WebAppInterface` 类允许网页使用 `showToast()` 方法创建 `Toast` 消息。

您可以使用 `addJavascriptInterface()` 将此类与 `WebView` 中运行的 `JavaScript` 绑定，并将接口命名为 `Android`。 例如：

```java
WebView webView = (WebView) findViewById(R.id.webview);
webView.addJavascriptInterface(new WebAppInterface(this), "Android");
```

这将创建一个名为 `Android` 的接口，用于在 `WebView` 中运行的 `JavaScript`。 此时，您的Web应用程序可以访问 `WebAppInterface` 类。 例如，以下是一些 `HTML` 和 `JavaScript`，它们在用户单击按钮时使用新界面创建 `toast` 消息：

```html
<input type="button" value="Say hello" onClick="showAndroidToast('Hello Android!')" />

<script type="text/javascript">
    function showAndroidToast(toast) {
        Android.showToast(toast);
    }
</script>
```

无需从 `JavaScript` 初始化 `Android` 接口。 `WebView` 会自动使其可用于您的网页。 因此，当用户单击按钮时，`showAndroidToast()` 函数将使用 `Android` 接口来调用 `WebAppInterface.showToast()` 方法。

> 注意：绑定到JavaScript的对象在另一个线程中运行，而不是在构造它的线程中运行。

**注意**：使用 `addJavascriptInterface()` 允许 `JavaScript` 控制您的 `Android` 应用。 这可能是非常有用的功能，也可能是危险的安全问题。 当 `WebView` 中的 `HTML` 不可信时（例如，部分或全部HTML由未知人员或进程提供），则攻击者可以包括执行您的客户端代码以及可能由攻击者选择的任何代码的HTML。 因此，除非编写了出现在 `WebView` 中的所有 `HTML` 和 `JavaScript`，否则不应使用 `addJavascriptInterface()`。 您还应该不允许用户在 `WebView` 中导航到非您自己的其他网页。 相反，应允许用户的默认浏览器应用程序打开外部链接-默认情况下，用户的Web浏览器将打开所有URL链接，因此，仅当您按以下部分所述处理页面导航时，请格外小心。


