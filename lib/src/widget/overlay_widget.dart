import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ToastAlignment { top, center, bottom }

class OverlayConst {
  static const Duration short = Duration(seconds: 1, milliseconds: 500);
  static const Duration long = Duration(seconds: 3);
  static const maskColor = Color(0x44000000);
  static const textStyle = TextStyle(
      color: Colors.white, fontSize: 13, decoration: TextDecoration.none);
}

class _SimpleToastWidget extends StatelessWidget {
  static const _defMargin =
      EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 32);

  final String message;
  final Alignment alignment;
  final EdgeInsets margin;
  final bool passTouch;

  const _SimpleToastWidget(
      {required this.message,
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

class _SimpleLoadingDialog extends StatelessWidget {
  final bool passTouch;
  final Color maskColor;
  final Color frameColor;
  final TextStyle textStyle;
  final Color progressColor;
  final Color progressBackgroundColor;
  final String message;
  final double progressSize;
  final double progressStrokeWidth;

  const _SimpleLoadingDialog({
    this.message = "",
    this.passTouch = false,
    this.maskColor = OverlayConst.maskColor,
    this.frameColor = OverlayConst.maskColor,
    this.textStyle = OverlayConst.textStyle,
    this.progressSize = 24,
    this.progressColor = Colors.white,
    this.progressStrokeWidth = 3,
    this.progressBackgroundColor = Colors.transparent,
  });

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
                            child: CupertinoActivityIndicator(
                              color: progressColor,
                              radius: progressSize,
                            ),
                            // child: CircularProgressIndicator(
                            //   color: progressColor,
                            //   backgroundColor: progressBackgroundColor,
                            //   strokeWidth: progressStrokeWidth,
                            // ),
                          ),
                          if (message.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                message,
                                style: textStyle,
                              ),
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

Widget buildDefToastOverlay(
  BuildContext context, {
  String? message,
  int duration = 2,
  bool passTouch = true,
  ToastAlignment alignment = ToastAlignment.bottom,
}) {
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

  return _SimpleToastWidget(
      message: message ?? "",
      passTouch: passTouch,
      alignment: posAlignment,
      margin: EdgeInsets.only(
          left: 16, right: 16, top: marginTop, bottom: marginBottom));
}

Widget buildDefLoadingOverlay(
  BuildContext context, {
  String message = "",
  bool passTouch = false,
  Color maskColor = OverlayConst.maskColor,
  Color frameColor = Colors.transparent,
  TextStyle textStyle = OverlayConst.textStyle,
  double progressSize = 24,
  Color progressColor = Colors.white,
  double progressStrokeWidth = 2,
  Color progressBackgroundColor = Colors.transparent,
}) {
  return _SimpleLoadingDialog(
    message: message,
    passTouch: passTouch,
    maskColor: maskColor,
    frameColor: frameColor,
    textStyle: textStyle,
    progressColor: progressColor,
    progressSize: progressSize,
  );
}
