import 'package:flutter/material.dart';

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