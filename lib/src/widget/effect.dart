import 'package:flutter/material.dart';

/// 点击时子组件有淡出效果。
class FadeEffect extends StatefulWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final double opacity;

  const FadeEffect(
      {super.key, required this.child, this.onTap, this.opacity = 0.6});

  @override
  State<FadeEffect> createState() => _FadeEffectState();
}

class _FadeEffectState extends State<FadeEffect> {
  double opacity = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        onTapDown: (event) {
          setState(() {
            opacity = widget.opacity;
          });
        },
        onTapUp: (event) {
          setState(() {
            opacity = 1;
          });
        },
        child: Opacity(
          opacity: opacity,
          child: widget.child,
        ));
  }
}
