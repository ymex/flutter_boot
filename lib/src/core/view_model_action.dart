import 'package:flutter/cupertino.dart';
import 'package:flutter_boot/http.dart';

import '../../widget.dart';
import 'view_model.dart';

mixin ActionVmMixin {
  Function(
    String message, {
    int duration,
    ToastAlignment alignment,
    Widget? widget,
  })? toastCall;

  Function({Widget? widget})? showLoadingCall;

  VoidCallback? dismissLoadingCall;

  void toast(
    String message, {
    int duration = 2,
    ToastAlignment alignment = ToastAlignment.bottom,
    Widget? widget,
  }) {
    if (toastCall != null) {
      toastCall!(message,
          duration: duration, alignment: alignment, widget: widget);
    }
  }

  void showLoading({Widget? widget}) {
    if (showLoadingCall != null) {
      showLoadingCall!(widget: widget);
    }
  }

  void dismissLoading() {
    if (dismissLoadingCall != null) {
      dismissLoadingCall!();
    }
  }
}

class ActionViewModel extends ViewModel with ActionVmMixin {
  ActionViewModel({super.key});
}

class HttpViewModel extends ViewModel with ActionVmMixin, AnHttpMixin {
  HttpViewModel({super.key});
}
