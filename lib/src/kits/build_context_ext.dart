import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  /// 屏幕宽度
  double get screenWidth => MediaQuery.of(this).size.width;

  /// 屏幕高度
  double get screenHeight => MediaQuery.of(this).size.height;

  /// 状态栏高度
  double get stateBarHeight => MediaQuery.of(this).padding.top;

  /// ToolBar 高度
  double get toolBarHeight => kToolbarHeight;

  /// AppBar 高度
  double get appBarHeight => stateBarHeight + toolBarHeight;

  /// 获取组件在屏幕中的坐标
  Rect? get paintBounds {
    final renderObject = findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }

  /// 获取组件的宽高
  Size? get paintBoundsSize {
    var rect = paintBounds;
    if (rect == null) return null;
    return Size(rect.right - rect.left, rect.bottom - rect.top);
  }

  /// 命名路由参数
  Object? get arguments => ModalRoute.of(this)?.settings.arguments;
}
