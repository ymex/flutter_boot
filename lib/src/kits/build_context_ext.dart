
import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext{

  /// 屏幕宽度
  double screenWidth(){
    return MediaQuery.of(this).size.width;
  }

  /// 屏幕高度
  double screenHeight(){
    return MediaQuery.of(this).size.height;
  }


  /// 状态栏高度
  double stateBarHeight(){
    return  MediaQuery.of(this).padding.top;
  }


  double appBarHeight(){
    return kToolbarHeight;
  }


}