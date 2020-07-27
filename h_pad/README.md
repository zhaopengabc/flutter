<!--
 * @Description: Do not edit
 * @Author: benmo
 * @Date: 2020-02-11 19:42:58
 * @LastEditors: benmo
 -->
# h_pad

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

###   flutter常用命令

```

  --version	查看Flutter版本
  -h或者**--help**	打印所有命令行用法信息
  analyze	分析项目的Dart代码。
  build	Flutter构建命令。
  channel	列表或开关Flutter通道。
  clean	删除构建/目录。
  config	配置Flutter设置。
  create	创建一个新的Flutter项目。
  devices	列出所有连接的设备。
  doctor	展示了有关安装工具的信息。
  drive	为当前项目运行Flutter驱动程序测试。
  format	格式一个或多个Dart文件。
  fuchsia_reload	在Fuchsia上进行热重载。
  help	显示帮助信息的Flutter。
  install	在附加设备上安装Flutter应用程序。
  logs	显示用于运行Flutter应用程序的日志输出。
  packages	命令用于管理Flutter包。
  precache	填充了Flutter工具的二进制工件缓存。
  run	在附加设备上运行你的Flutter应用程序。
  screenshot	从一个连接的设备截图。
  stop	停止在附加设备上的Flutter应用。
  test	对当前项目的Flutter单元测试。
  trace	开始并停止跟踪运行的Flutter应用程序。
  upgrade	升级你的Flutter副本。

```
```
.
├── README.md
├── assets
│   ├── config.json
│   ├── fonts
│   ├── images
│   └── pdf
├── jsons
├── lib
│   ├── api
│   ├── common
│   ├── constants
│   ├── i18n
│   ├── main.dart
│   ├── models
│   ├── routes
│   ├── style
│   │   ├── colors.dart
│   │   ├── icons.dart
│   │   ├── index.dart
│   │   ├── strings.dart
│   │   └── style.dart
│   ├── theme
│   │   ├── themColor.dart
│   │   └── themeProvide.dart
│   ├── utils
│   ├── views
│   │   ├── Edit
│   │   ├── Init
│   │   ├── Language
│   │   ├── Layout.dart
│   │   └── Login
│   └── widgets
├── locale
├── pubspec.yaml
└── test
```

# 生成 model类
flutter packages pub run json_model // 生成 数据model

debugDumpRenderTree(); // 打印 widget 结构


### app 打包流程

## android 端
```
  flutter build  apk
```
## ios

首先 在 vscode 运行指令
```
 flutter build ios

 # 打开 xcode

  1. 设备选择  Generic iOS Device
  2. 选择 Product 的 Archive 等待打包完成
```
