import 'package:flutter/material.dart';
import 'package:flutter_boot/kits.dart';
import 'package:flutter_boot/widget.dart';

class OverlayAction {
  static OverlayAction? _instance;
  BuildContext? _context;
  late OverlayTier _toastTier;
  late OverlayTier _loadingTier;
  late OverlayTier _overlayTier;

  ///页面生命周期结束时、取消自动隐藏toast 与 dialog
  @Deprecated("向前兼容")
  static bool autoDismissWithLife = false;

  OverlayAction._internal() {
    _toastTier = OverlayTier();
    _loadingTier = OverlayTier();
    _overlayTier = OverlayTier();
  }

  static void init(BuildContext context) {
    getInstance()._context = context;
  }

  static OverlayAction getInstance() {
    _instance ??= OverlayAction._internal();
    return _instance!;
  }

  static void overlay(
    BuildContext context,
    Widget widget, {
    Duration? duration,
    bool opaque = false,
    bool maintainState = false,
    bool replace = true,
  }) {
    getInstance()._overlayTier.show(context, widget,
        duration: duration,
        opaque: opaque,
        maintainState: maintainState,
        replace: replace);
  }

  static void toast({
    String? message,
    Widget? widget,
    ToastAlignment alignment = ToastAlignment.bottom,
    Duration? duration,
    bool opaque = false,
    bool maintainState = false,
    bool replace = true,
  }) {
    var context = getInstance()._context;
    if (context == null) {
      logI("Error:need init BootOverlay!");
      return;
    }
    var widgetView = widget;
    if (widget == null) {
      widgetView = buildDefToastOverlay(context,
          message: message, duration: 2, alignment: alignment);
    }
    getInstance()._toastTier.show(context, widgetView!,
        duration: duration ?? const Duration(seconds: 2),
        opaque: opaque,
        maintainState: maintainState,
        replace: replace);
  }

  static void loading({
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
    var context = getInstance()._context;
    if (context == null) {
      logI("Error:need init OverlayAction! use OverlayAction.init(context) or BootScopeMixin");
      return;
    }
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
    getInstance()._loadingTier.show(context, widgetView!,
        duration: duration,
        opaque: opaque,
        maintainState: maintainState,
        replace: replace);
  }

  static void dismissLoading() {
    getInstance()._loadingTier.dismiss();
  }

  static void dismissToast() {
    getInstance()._toastTier.dismiss();
  }
}

mixin OverlayActionMixin{

  void toast(
      String message, {
        int duration = 2,
        ToastAlignment alignment = ToastAlignment.bottom,
        Widget? widget,
      }) {
    OverlayAction.toast(
        message: message,
        duration: Duration(seconds: duration),
        alignment: alignment,
        widget: widget);
  }

  void dismissToast(){
    OverlayAction.dismissToast();
  }

  void showLoading({Widget? widget}) {
    OverlayAction.loading(widget: widget);
  }

  void dismissLoading() {
    OverlayAction.dismissLoading();
  }
}