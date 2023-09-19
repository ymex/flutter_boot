import 'dart:async';
import 'package:flutter/material.dart';

class OverlayTier extends OverlayEntry {
  Timer? _timer;
  Duration? duration;

  //显示中 ？
  bool _isShowing = false;

  OverlayTier(
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