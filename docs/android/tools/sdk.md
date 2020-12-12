## Download sdk

[https://developer.android.com/studio/index.html](https://developer.android.com/studio/index.html)

> wget [https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip](https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip)
>
> unzip [sdk-tools-linux-3859397.zip](https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip)  ./android-sdk

## Config

_Force all connections to use http rather than https._

> ./android-sdk/tools/sdkmanager --update --no\_https

## Install

* 查看

> sdkmanager --list

* 安装

```
sdkmanager "platforms;android-26"
sdkmanager "build-tools;25.0.3"
sdkmanager "extras;google;m2repository"
sdkmanager "extras;android;m2repository"
sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2"
sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2"
```

## Issue

_Warning: File /root/.android/repositories.cfg could not be loaded._

> touch /root/.android/repositories.cfg



