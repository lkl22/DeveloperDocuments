# 缩减apk大小

apk大小直接影响用户下载，用户留存，下载流量，安装占用手机内存。

* [分析工具 - Apk Analyzer](#ApkAnalyzer)
* [classes.dex的优化](#classes.dex的优化)
  * [android压缩代码和资源](#android压缩代码和资源)
* [资源的优化](#资源的优化)
  * [图片资源压缩](#图片资源压缩)
  * [语言压缩](#语言压缩)
  * [开启资源压缩](#开启资源压缩)
* [参考文献](#参考文献)

## <a name="ApkAnalyzer">[分析工具 - Apk Analyzer](../tools/apkAnalyzer.md)<a/>

apk构成可以通过studio自带的工具分析，占用最大的文件，提供优化方向。可以从对应章节查看相应内容。

## <a name="classes.dex的优化">classes.dex的优化<a/>

如何优化classes.dex的大小呢？大约有以下几种套路：

1. 保持良好的编程习惯和对包体积敏锐的嗅觉，去除重复或者不用的代码，**慎用第三方库，选用体积小的第三方SDK**。
2. 开启 `ProGuard`，通过使用 `ProGuard` 来对代码进行混淆、优化、压缩等工作

> 第一个方案对程序猿的素质要求比较高，项目经验也很重要，所以因人而异。

### <a name="android压缩代码和资源">android压缩代码和资源<a/>

要尽可能减小 APK 文件，您应该启用压缩来移除发布构建中未使用的代码和资源。

代码压缩通过 [ProGuard](./proGuard.md) 提供，`ProGuard` 会检测和移除封装应用中未使用的类、字段、方法和属性，包括自带代码库中的未使用项（这使其成为以变通方式解决 64k 引用限制的有用工具）。`ProGuard` 还可优化字节码，移除未使用的代码指令，以及用短名称混淆其余的类、字段和方法。混淆过的代码可令您的 `APK` 难以被逆向工程，这在应用使用许可验证等安全敏感性功能时特别有用。

[缩减、混淆处理和优化应用](./shrinkCode.md) 将指导怎么通过配置缩减代码及资源。

## <a name="资源的优化">资源的优化<a/>

对于资源的优化也是最行之有效，最为直观的优化方案。通过对资源文件的优化，可以大大的减小apk体积大小。

### <a name="图片资源压缩">图片资源压缩<a/>

图片资源是apk中占比比较大的，大量的使用大图会导致apk体积很大，所以图片的优化对apk压缩往往能起到立竿见影的效果。

为了支持Android设备DPI的多样化（`[l|m|tv|h|x|xx|xxx]dpi`）以及用户对高质量UI的期待，往往在App中使用了大量的图片以及不同的格式，例如：`PNG`、`JPG` 、`WebP`，那我们该怎么选择不同类型的图片格式呢？  

Google I/O 2016大会上推荐使用WebP格式图片，可以大大减少体积，而显示又不失真。

![](./shrinkApk/imgs/pic-select.png)

通过上图我们可以看出图片格式选择的方法：如果能用 `VectorDrawable` 来表示的话优先使用 `VectorDrawable`，如果支持 `WebP` 则优先用 `WebP`，而 `PNG` 主要用在展示透明或者简单的图片，而其它场景可以使用 `JPG` 格式。这样就达到了什么场景选什么图片更好。

1. 不影响显示效果的前提下，降低图片质量

2. 或者通过一些专业工具优化压缩图片，比如 [tinypng](https://github.com/lkl22/CommonTools/blob/master/util/TinifyUtil.py)

3. `svg` 转化 `xml` 图片，矢量图，google 推广 `material design`以来，很多icon都已经提供，可以直接下载使用，转换成`xml`之后，可以使 `apksize` 的大小明显降低（实践证明这个用在支持较低版本的sdk的时候会有问题，需要特殊处理）,主要针对 `200dp * 200dp` 以内的位图，超过了会影响 cpu 效率。

> 使用矢量图片能够有效的减少App中图片所占用的大小，矢量图形在Android中表示为VectorDrawable对象。 使用VectorDrawable对象，100字节的文件可以生成屏幕大小的清晰图像，但系统渲染每个VectorDrawable对象需要大量的时间，较大的图像需要更长的时间才能出现在屏幕上。 **因此只有在显示小图像时才考虑使用矢量图形**。

4. 按钮避免使用`selector`，5.0以后的版本使用`tintcolor`可以避免为一个button提供两张图片

5. [webP](https://developers.google.cn/speed/webp/?hl=zh_cn) 来替换传统的 `png`、`jpg` 格式的图片

`WebP` WebP 是 Google 的一种可以同时提供有损压缩（像 JPEG 一样）和透明度（像 PNG 一样）的图片文件格式，不过与 JPEG 或 PNG 相比，这种格式可以提供更好的压缩。`Android 4.0（API 级别 14）`及更高版本支持有损 WebP 图片，`Android 4.3（API 级别 18）`及更高版本支持无损且透明的 `WebP` 图片。这种格式为网络图像提供了卓越的无损和有损压缩。 使用 `WebP`，开发人员可以创建更小，更丰富的图像。 `WebP` 无损图像文件平均比 `PNG` 小 26% 。 这些图像文件还支持透明度（也称为 `alpha` 通道），成本只有 22% 的字节。

`WebP` 有损图像比同等 SSIM 质量指数下的 `JPG` 图像小 25-34% 。 对于可接受有损 RGB 压缩的场景，有损 `WebP` 还能支持透明度，产生的文件大小通常比 PNG 小 3 倍。

### 语言压缩

在 app/build.gradle 添加

```groovy
android {
    defaultConfig {
        ...
        //只保留中英文
        resConfigs "en", "zh"
    }
}
```

我们只需要将需要的语言的翻译资源打包进 apk，通过配置可以将多余的字符串资源从 apk 中移除。

### 开启资源压缩

Android的编译工具链中提供了一款资源压缩的工具，可以通过该工具来压缩资源，如果要启用资源压缩，可以在build.gradle文件中启用，例如：

```groovy
android {
    ...
    buildTypes {
        release {
            shrinkResources true
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

Android构建工具是通过 `ResourceUsageAnalyzer` 来检查哪些资源是无用的，当检查到无用的资源时会把该资源替换成预定义的版本。

如果想知道哪些资源是无用的，可以通过资源压缩工具的输出日志文件${project.buildDir}/outputs/mapping/release/resources.txt来查看。例如：

![](./shrinkApk/imgs/mapping-resources.png)

**资源压缩工具只是把无用资源替换为小的虚拟文件**，那我们如何删除这些无用资源呢？通常的做法是结合资源压缩工具的输出日志，找到这些资源并把它们进行删除。




## <a name="参考文献">参考文献<a/>

[适用于 Android 的 Material Design](https://developer.android.google.cn/guide/topics/ui/look-and-feel?hl=zh_cn)

[添加多密度矢量图形](https://developer.android.google.cn/studio/write/vector-asset-studio?hl=zh_cn#importing)

[创建 WebP 图片](https://developer.android.google.cn/studio/write/convert-webp?hl=zh_cn)

