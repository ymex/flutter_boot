import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///设置状态栏, 如果flutter 是第一个启动的页面。
///则app主题样式为flutter 设置的。 若不是首个则
///样式跟随原生App

void systemUiStyleLight() {
  SystemUiOverlayStyle style = SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    //状态栏颜色
    systemNavigationBarColor: Colors.transparent,
    //导航栏颜色
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );
  systemUIOverlayStyle(style);
}

void systemUiStyleDark() {
  SystemUiOverlayStyle style = SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  systemUIOverlayStyle(style);
}

void systemUIOverlayStyle(SystemUiOverlayStyle style) {
  SystemChrome.setSystemUIOverlayStyle(style);
}

/// 设置是否隐藏状态栏或导航栏
/// SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);// 隐藏状态栏，底部按钮栏
/// SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);//隐藏状态栏，保留底部按钮栏
/// SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);//显示状态栏、底部按钮栏
///
/// leanBack: 全屏显示，状态和导航栏可通过点击显示器上的任何地方呈现。
/// 从SDK 16或Android j开始可用。早期版本的Android将不受此设置的影响。
/// 对于在iOS上运行的应用程序，状态栏和home指示器将被隐藏，以获得类似的全屏体验。
///
/// immersive:全屏显示，状态和导航条可以通过在显示器边缘的滑动手势呈现。
/// 从SDK 19或Android k开始可用。早期版本的Android将不受此设置的影响。
/// 对于在iOS上运行的应用程序，状态栏和home指示器将被隐藏，以获得类似的全屏体验。
/// 从屏幕边缘滑动手势显示叠加。与[SystemUiMode。，这个手势不会被应用程序接收。
///
/// immersiveSticky: 全屏显示，状态和导航条可以通过在显示器边缘的滑动手势呈现。
/// 从SDK 19或Android k开始可用。早期版本的Android将不受此设置的影响。
/// 对于在iOS上运行的应用程序，状态栏和home指示器将被隐藏，以获得类似的全屏体验。
/// 从屏幕边缘滑动手势显示叠加。与[SystemUiMode。，这个手势被应用程序接收。
///
/// edgeToEdge: 全屏显示，在应用程序上呈现状态和导航元素。
/// 从SDK 29或Android 10开始可用。早期版本的Android将不受此设置的影响。
/// 对于在iOS上运行的应用程序，状态栏和home指示器将是可见的。在此模式下，
/// 系统覆盖不会消失或重新出现，因为它们将永久显示在应用程序的顶部。
///
/// manual:声明手动配置的[SystemUiOverlay]s。
/// 当使用此模式与[SystemChrome.setEnabledSystemUIMode],首选覆盖必须由开发人员设置。
/// 当[SystemUiOverlay.top]启用后，状态栏将保持可见在所有平台上。省略这个覆盖将隐藏iOS和android上的状态栏。
/// 当[SystemUiOverlay.bottom]启用时，Android和iOS应用的导航栏和主界面指示器将保持可见。省略这个覆盖层将隐藏它们。
/// 省略这两个覆盖将导致与[SystemUiMode.leanBack]相同的配置。

Future systemEnabledUiMode(
    {SystemUiMode mode = SystemUiMode.edgeToEdge,
    List<SystemUiOverlay>? overlays}) async {
  return SystemChrome.setEnabledSystemUIMode(mode, overlays: overlays);
}

/// 设置屏幕方向
/// [DeviceOrientation.portraitUp] - 竖屏
/// [DeviceOrientation.landscapeLeft] - 横屏
void systemScreenOrientation(
    {required List<DeviceOrientation> orientations}) async {
  return SystemChrome.setPreferredOrientations(orientations);
}

/// 关闭键盘
void systemHideKeyboard({bool hideFocus = false}) async {
  if (hideFocus) {
    /// 关闭键盘并失去焦点
    return FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 关闭键盘并保留焦点
  return SystemChannels.textInput.invokeMethod('TextInput.hide');
}
