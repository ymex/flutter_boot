import 'package:flutter/material.dart';

/// 点击时子组件有淡出效果。
class FadeEffect extends StatefulWidget {
  final HitTestBehavior? behavior;
  final Widget child;
  final GestureTapCallback? onTap;
  final double opacity;

  const FadeEffect({
    super.key,
    required this.child,
    this.onTap,
    this.opacity = 0.6,
    this.behavior,
  });

  @override
  State<FadeEffect> createState() => _FadeEffectState();
}

class _FadeEffectState extends State<FadeEffect> {
  double opacity = 1;

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) {
      return widget.child;
    }
    return GestureDetector(
        behavior: widget.behavior,
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
        onTapCancel: () {
          setState(() {
            opacity = 1;
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

class AnimationFadeEffect extends StatefulWidget {
  final HitTestBehavior? behavior;
  final Widget child;
  final GestureTapCallback? onTap;
  final double opacity;

  final int duration; //milliseconds

  const AnimationFadeEffect({
    super.key,
    required this.child,
    this.onTap,
    this.opacity = 0.6,
    this.duration = 150,
    this.behavior,
  });

  @override
  State<AnimationFadeEffect> createState() => _AnimationFadeEffectState();
}

class _AnimationFadeEffectState extends State<AnimationFadeEffect>
    with SingleTickerProviderStateMixin {
  double opacity = 1;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) {
      return widget.child;
    }
    _controller ??= AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));
    return GestureDetector(
      behavior: widget.behavior,
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapUp: (event) {
        _controller?.reverse();
      },
      onTapCancel: () {
        _controller?.reverse();
      },
      onTapDown: (event) {
        _controller?.forward();
      },
      child: FadeTransition(
          opacity: Tween(begin: 1.0, end: widget.opacity).animate(_controller!),
          child: widget.child),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
