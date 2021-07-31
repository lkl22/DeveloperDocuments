# 缩减apk大小

apk大小直接影响用户下载，用户留存，下载流量，安装占用手机内存。

* [分析工具 - Apk Analyzer](#ApkAnalyzer)
* [android压缩代码和资源](#android压缩代码和资源)
* [图片资源压缩](#图片资源压缩)
* [多语言压缩](#多语言压缩)
* [参考文献](#参考文献)

## <a name="ApkAnalyzer">[分析工具 - Apk Analyzer](../tools/apkAnalyzer.md)<a/>

apk构成可以通过studio自带的工具分析，占用最大的文件，提供优化方向。可以从对应章节查看相应内容。

## <a name="android压缩代码和资源">android压缩代码和资源<a/>

要尽可能减小 APK 文件，您应该启用压缩来移除发布构建中未使用的代码和资源。

代码压缩通过 [ProGuard](./proGuard.md) 提供，`ProGuard` 会检测和移除封装应用中未使用的类、字段、方法和属性，包括自带代码库中的未使用项（这使其成为以变通方式解决 64k 引用限制的有用工具）。`ProGuard` 还可优化字节码，移除未使用的代码指令，以及用短名称混淆其余的类、字段和方法。混淆过的代码可令您的 `APK` 难以被逆向工程，这在应用使用许可验证等安全敏感性功能时特别有用。

[缩减、混淆处理和优化应用](./shrinkCode.md) 将指导怎么通过配置缩减代码及资源。

## <a name="图片资源压缩">图片资源压缩<a/>

图片资源是apk中占比比较大的，大量的使用大图会导致apk体积很大，所以图片的优化对apk压缩往往能起到立竿见影的效果。

1. 不影响显示效果的前提下，降低图片质量

2. 或者通过一些专业工具优化压缩图片，比如 [tinypng](https://github.com/lkl22/CommonTools/blob/master/util/TinifyUtil.py)

3. `svg` 转化 `xml` 图片，矢量图，google 推广 `material design`以来，很多icon都已经提供，可以直接下载使用，转换成`xml`之后，可以使 `apksize` 的大小明显降低（实践证明这个用在支持较低版本的sdk的时候会有问题，需要特殊处理）,主要针对 `200dp * 200dp` 以内的位图，超过了会影响 cpu 效率。

4. 按钮避免使用`selector`，5.0以后的版本使用`tintcolor`可以避免为一个button提供两张图片

5. [webP](https://developers.google.cn/speed/webp/?hl=zh_cn) 来替换传统的 `png`、`jpg` 格式的图片

`WebP` WebP 是 Google 的一种可以同时提供有损压缩（像 JPEG 一样）和透明度（像 PNG 一样）的图片文件格式，不过与 JPEG 或 PNG 相比，这种格式可以提供更好的压缩。`Android 4.0（API 级别 14）`及更高版本支持有损 WebP 图片，`Android 4.3（API 级别 18）`及更高版本支持无损且透明的 `WebP` 图片。这种格式为网络图像提供了卓越的无损和有损压缩。 使用 `WebP`，开发人员可以创建更小，更丰富的图像。 `WebP` 无损图像文件平均比 `PNG` 小 26% 。 这些图像文件还支持透明度（也称为 `alpha` 通道），成本只有 22% 的字节。

`WebP` 有损图像比同等 SSIM 质量指数下的 `JPG` 图像小 25-34% 。 对于可接受有损 RGB 压缩的场景，有损 `WebP` 还能支持透明度，产生的文件大小通常比 PNG 小 3 倍。

## 多语言压缩

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




## <a name="参考文献">参考文献<a/>

[适用于 Android 的 Material Design](https://developer.android.google.cn/guide/topics/ui/look-and-feel?hl=zh_cn)

[添加多密度矢量图形](https://developer.android.google.cn/studio/write/vector-asset-studio?hl=zh_cn#importing)

[创建 WebP 图片](https://developer.android.google.cn/studio/write/convert-webp?hl=zh_cn)

