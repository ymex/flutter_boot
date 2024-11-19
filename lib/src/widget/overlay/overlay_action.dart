import 'package:flutter/material.dart';
import 'package:flutter_boot/widget.dart';

class OverlayAction {
  final BuildContext context;
  late OverlayTier _toastTier;
  late OverlayTier _loadingTier;
  late OverlayTier _overlayTier;

  OverlayAction(this.context) {
    _toastTier = OverlayTier();
    _loadingTier = OverlayTier();
    _overlayTier = OverlayTier();
  }

  void overlay(
    BuildContext context,
    Widget widget, {
    Duration? duration,
    bool opaque = false,
    bool maintainState = false,
    bool replace = true,
  }) {
    _overlayTier.show(context, widget,
        duration: duration,
        opaque: opaque,
        maintainState: maintainState,
        replace: replace);
  }

  void toast({
    String? message,
    Widget? widget,
    ToastAlignment alignment = ToastAlignment.bottom,
    Duration? duration,
    bool opaque = false,
    bool maintainState = false,
    bool replace = true,
  }) {
    var widgetView = widget;
    if (widget == null) {
      widgetView = buildDefToastOverlay(context,
          message: message, duration: 2, alignment: alignment);
    }
    _toastTier.show(context, widgetView!,
        duration: duration ?? const Duration(seconds: 2),
        opaque: opaque,
        maintainState: maintainState,
        replace: replace);
  }

  void loading({
    Widget? widget,
    Duration? duration,
    bool opaque = false,
    bool maintainState = false,
    bool replace = true,
    String message = "",
    bool passTouch = false,
    Color maskColor = OverlayConst.maskColor,
    Color frameColor = Colors.transparent,
    TextStyle textStyle = OverlayConst.textStyle,
    double progressSize = 13,
    Color progressColor = Colors.white,
    double progressStrokeWidth = 2,
    Color progressBackgroundColor = Colors.transparent,
  }) {
    var widgetView = widget;
    if (widget == null) {
      widgetView = buildDefLoadingOverlay(
        context,
        message: message,
        passTouch: passTouch,
        maskColor: maskColor,
        frameColor: frameColor,
        textStyle: textStyle,
        progressSize: progressSize,
        progressColor: progressColor,
        progressStrokeWidth: progressStrokeWidth,
        progressBackgroundColor: progressBackgroundColor,
      );
    }
    _loadingTier.show(context, widgetView!,
        duration: duration,
        opaque: opaque,
        maintainState: maintainState,
        replace: replace);
  }

  void dismissLoading() {
    _loadingTier.dismiss();
  }

  void dismissToast() {
    _toastTier.dismiss();
  }
}

mixin OverlayActionMixin {
  late OverlayAction? overlayAction;

  ///页面生命周期结束时、取消自动隐藏toast
  bool get autoDismissToast => true;

  ///页面生命周期结束时、取消自动隐藏 dialog
  bool get autoDismissLoading => true;

  void setOverlayAction(OverlayAction? action) {
    overlayAction = action;
  }

  void toast(
    String message, {
    int duration = 2,
    ToastAlignment alignment = ToastAlignment.bottom,
    Widget? widget,
  }) {
    overlayAction?.toast(
        message: message,
        duration: Duration(seconds: duration),
        alignment: alignment,
        widget: widget);
  }

  void dismissToast() {
    overlayAction?.dismissToast();
  }

  void showLoading({Widget? widget}) {
    overlayAction?.loading(widget: widget);
  }

  void dismissLoading() {
    overlayAction?.dismissLoading();
  }

  void disposeOverlayAction() {
    if (autoDismissToast) dismissToast();
    if (autoDismissLoading) dismissLoading();
  }
}
