import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_boot/src/widget/overlay_tier.dart';

enum ToastAlignment { top, center, bottom }

class SimpleToastWidget extends StatelessWidget {
  static const _defMargin =
      EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 32);

  final String message;
  final Alignment alignment;
  final EdgeInsets margin;
  final bool passTouch;

  const SimpleToastWidget(
      {super.key,
      required this.message,
      this.alignment = Alignment.bottomCenter,
      this.margin = _defMargin,
      this.passTouch = true});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: passTouch,
      child: Stack(
        children: [
          Positioned(
            child: Align(
              alignment: alignment,
              child: Padding(
                padding: margin,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24)),
                    child: Text(
                      message,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          decoration: TextDecoration.none),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SimpleLoadingDialog extends StatelessWidget {
  final bool passTouch;
  final Color maskColor;
  final Color frameColor;
  final TextStyle textStyle;
  final Color progressColor;
  final String message;
  final double progressSize;

  static const _maskColor = Color(0x55000000);
  static const _textStyle = TextStyle(
      color: Colors.white, fontSize: 13, decoration: TextDecoration.none);

  const SimpleLoadingDialog(
      {super.key,
      this.message = "loading...",
      this.passTouch = false,
      this.maskColor = _maskColor,
      this.frameColor = _maskColor,
      this.textStyle = _textStyle,
      this.progressSize = 28,
      this.progressColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: passTouch,
      child: ColoredBox(
        color: maskColor,
        child: Stack(
          children: [
            Positioned(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                          color: frameColor,
                          borderRadius: BorderRadius.circular(24)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: progressSize,
                            width: progressSize,
                            child: CircularProgressIndicator(
                              color: progressColor,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            message,
                            style: textStyle,
                          )
                        ],
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

mixin HintOverlay<T extends StatefulWidget> on State<T> {
  OverlayTier? _toastTier;
  OverlayTier? _loadingTier;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _toastTier?.dismiss();
    _loadingTier?.dismiss();
    _toastTier = null;
    _loadingTier = null;
    super.dispose();
  }


  void _toastWidget(Widget widget, {int duration = 2}) {
    _toastTier?.dismiss();

    _toastTier = OverlayTier(
      duration: Duration(seconds: duration),
      opaque: false, //不透明
      builder: (_) {
        return Material(type: MaterialType.transparency, child: widget);
      },
    );
    _toastTier?.show(context);
  }

  /// 自定义 toast UI
  /// [widget] UI
  /// [duration] 显示的时长，单位秒
  void toastWidget(Widget widget, {int duration = 2}) {
    _toastWidget(widget, duration: duration);
  }

  /// toast
  /// [message] 提醒的文字
  /// [duration] 显示的时长，单位秒
  /// [alignment] 显示的位置
  /// [margin] 边距
  void toast(String message,
      {int duration = 2, ToastAlignment alignment = ToastAlignment.bottom}) {
    var marginBottom = 0.0;
    var marginTop = 0.0;
    Alignment posAlignment;
    if (alignment == ToastAlignment.bottom) {
      marginBottom = MediaQuery.of(context).size.height / 7;
      posAlignment = Alignment.bottomCenter;
    } else if (alignment == ToastAlignment.top) {
      marginTop = MediaQuery.of(context).size.height / 7;
      posAlignment = Alignment.topCenter;
    } else {
      posAlignment = Alignment.center;
    }

    _toastWidget(
        SimpleToastWidget(
            message: message,
            alignment: posAlignment,
            margin: EdgeInsets.only(
                left: 16, right: 16, top: marginTop, bottom: marginBottom)),
        duration: duration);
  }

  void _showLoading(Widget widget) {
    if (_loadingTier != null && _loadingTier!.isShowing) {
      return;
    }
    _loadingTier?.dismiss();
    _loadingTier = OverlayTier(builder: (_) {
      return widget;
    });
    _loadingTier?.show(context);
  }

  void loadingWidget(Widget widget) {
    _showLoading(widget);
  }

  void loading() {
    _showLoading(const SimpleLoadingDialog());
  }

  void dismissLoading() {
    _loadingTier?.dismiss();
  }
}
