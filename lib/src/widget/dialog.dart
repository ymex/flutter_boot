import 'package:flutter/material.dart';
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