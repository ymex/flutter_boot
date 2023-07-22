import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///设置状态栏, 如果flutter 是第一个启动的页面。 则app主题样式为flutter 设置的。 若不是首个则
///样式跟随原生App

void systemUiStyleLight(){
  SystemUiOverlayStyle systemUiOverlayStyle =  SystemUiOverlayStyle.light.copyWith(
    statusBarColor:  Colors.transparent, //状态栏颜色
    systemNavigationBarColor:Colors.transparent, //导航栏颜色
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}


void systemUiStyleDark(){
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle.dark.copyWith(
    statusBarColor:  Colors.transparent,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

/// 设置是否隐藏状态栏或导航栏
void systemEnabledUiMode({SystemUiMode mode = SystemUiMode.manual, List<SystemUiOverlay>? overlays }){
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);//隐藏状态栏，底部按钮栏
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);//隐藏状态栏，保留底部按钮栏
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);//显示状态栏、底部按钮栏
  SystemChrome.setEnabledSystemUIMode(mode, overlays: overlays);
}

/// 设置屏幕方向 - 竖屏
void systemScreenOrientationPortrait() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
/// 设置屏幕方向 - 横屏
void systemScreenOrientationLandscape() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
}

/// 关闭键盘并保留焦点
Future<void> hideKeyShowfocus() async{
  await SystemChannels.textInput.invokeMethod('TextInput.hide');
}

/// 关闭键盘并失去焦点
Future<void> hideKeyShowUnfocus() async{
  FocusManager.instance.primaryFocus?.unfocus();
}