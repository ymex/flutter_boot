import 'dart:async';
import 'package:flutter/material.dart';

class TimeOverlayEntry extends OverlayEntry {
  Timer? _timer;
  Duration? duration;

  //显示中 ？
  bool _isShowing = false;

  TimeOverlayEntry(
      {required super.builder,
      this.duration,
      super.opaque,
      super.maintainState});

  bool get isShowing => _isShowing;

  void show(BuildContext context) {
    if (duration != null) {
      _timer = Timer(duration!, () {
        dismiss();
      });
    }

    Overlay.of(context).insert(this);
    _isShowing = true;
  }

  void dismiss() {
    _timer?.cancel();
    _timer = null;
    remove();
  }

  @override
  void remove() {
    if (_isShowing) {
      _isShowing = false;
      super.remove();
    }
  }
}

class OverlayTier {
  TimeOverlayEntry? _tier;

  TimeOverlayEntry? get tier => _tier;

  void dismiss() {
    _tier?.dismiss();
    _tier = null;
  }

  OverlayTier? show(
    BuildContext context,
    Widget widget, {
    Duration? duration,
    bool opaque = false,
    bool maintainState = false,
    bool replace = true,
  }) {
    /// 不替换且显示中则不处理
    if(!replace && _tier != null && _tier!.isShowing){
      return this;
    }

    _tier?.dismiss();
    _tier = TimeOverlayEntry(
      duration: duration,
      maintainState: maintainState,
      opaque: opaque, //不透明
      builder: (_) {
        return Material(type: MaterialType.transparency, child: widget);
      },
    );
    _tier?.show(context);
    return this;
  }
}
