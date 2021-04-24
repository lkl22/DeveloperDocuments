# Issue

## Multiple dex files define Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

[https://stackoverflow.com/questions/49028119/multiple-dex-files-define-landroid-support-design-widget-coordinatorlayoutlayou](https://stackoverflow.com/questions/49028119/multiple-dex-files-define-landroid-support-design-widget-coordinatorlayoutlayou)

Update the library versions to 27.1.0 solve the isssue for me.

## Multiple dex files define 

删除Build文件，重新编译

## 'buildSrc' cannot be used as a project name as it is a reserved name.

可以尝试使用以下方法解决：

1. 打开你的 settings.gradle / settings.gradle.kts 文件

2. 将 "buildSrc" 从 included modules 移除

3. 重新编译

