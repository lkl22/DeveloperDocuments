## Download the NDK and Tools

[https://developer.android.google.cn/ndk/downloads/](https://developer.android.google.cn/ndk/downloads/)

To compile and debug native code for your app, you need the following components:

* The Android Native Development Kit \(NDK\): a set of tools that allows you to use C and C++ code with Android.
* CMake: an external build tool that works alongside Gradle to build your native library. You do not need this component if you only plan to use ndk-build.
* _LLDB_: the debugger Android Studio uses to debug native code.

You can install these components [using the SDK Manager](https://developer.android.google.cn/studio/intro/update.html#sdk-manager):

1. From an open project, select **Tools &gt; Android &gt; SDK Manager **from the main menu.
2. Click the **SDK Tools **tab.
3. Check the boxes next to **LLDB**, **CMake **and **NDK**
4. Click **Apply**, and then click **OK **in the next dialog.
5. When the installation is complete, click **Finish**, and then click **OK**.









