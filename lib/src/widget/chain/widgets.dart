import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot/widget.dart';

extension WidgetChainExt on Widget {
  /// 包裹当前组件
  Widget enfold(Widget Function(Widget child) builder) {
    return builder(this);
  }

  /// 有点击效果的点击事件
  Widget click(GestureTapCallback? onTap) {
    return AnimationFadeEffect(
      onTap: onTap,
      child: this,
    );
  }

  /// 点击事件
  Widget tap(GestureTapCallback? onTap) {
    return gestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque);
  }

  /// 用GestureDetector包裹当前组件
  Widget gestureDetector({
    Key? key,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCallback? onTap,
    GestureTapCancelCallback? onTapCancel,
    GestureTapCallback? onSecondaryTap,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    GestureTapCancelCallback? onSecondaryTapCancel,
    GestureTapDownCallback? onTertiaryTapDown,
    GestureTapUpCallback? onTertiaryTapUp,
    GestureTapCancelCallback? onTertiaryTapCancel,
    GestureTapDownCallback? onDoubleTapDown,
    GestureTapCallback? onDoubleTap,
    GestureTapCancelCallback? onDoubleTapCancel,
    GestureLongPressDownCallback? onLongPressDown,
    GestureLongPressCancelCallback? onLongPressCancel,
    GestureLongPressCallback? onLongPress,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureLongPressUpCallback? onLongPressUp,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressDownCallback? onSecondaryLongPressDown,
    GestureLongPressCancelCallback? onSecondaryLongPressCancel,
    GestureLongPressCallback? onSecondaryLongPress,
    GestureLongPressStartCallback? onSecondaryLongPressStart,
    GestureLongPressMoveUpdateCallback? onSecondaryLongPressMoveUpdate,
    GestureLongPressUpCallback? onSecondaryLongPressUp,
    GestureLongPressEndCallback? onSecondaryLongPressEnd,
    GestureLongPressDownCallback? onTertiaryLongPressDown,
    GestureLongPressCancelCallback? onTertiaryLongPressCancel,
    GestureLongPressCallback? onTertiaryLongPress,
    GestureLongPressStartCallback? onTertiaryLongPressStart,
    GestureLongPressMoveUpdateCallback? onTertiaryLongPressMoveUpdate,
    GestureLongPressUpCallback? onTertiaryLongPressUp,
    GestureLongPressEndCallback? onTertiaryLongPressEnd,
    GestureDragDownCallback? onVerticalDragDown,
    GestureDragStartCallback? onVerticalDragStart,
    GestureDragUpdateCallback? onVerticalDragUpdate,
    GestureDragEndCallback? onVerticalDragEnd,
    GestureDragCancelCallback? onVerticalDragCancel,
    GestureDragDownCallback? onHorizontalDragDown,
    GestureDragStartCallback? onHorizontalDragStart,
    GestureDragUpdateCallback? onHorizontalDragUpdate,
    GestureDragEndCallback? onHorizontalDragEnd,
    GestureDragCancelCallback? onHorizontalDragCancel,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureDragDownCallback? onPanDown,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragEndCallback? onPanEnd,
    GestureDragCancelCallback? onPanCancel,
    GestureScaleStartCallback? onScaleStart,
    GestureScaleUpdateCallback? onScaleUpdate,
    GestureScaleEndCallback? onScaleEnd,
    HitTestBehavior? behavior,
    bool excludeFromSemantics = false,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    bool trackpadScrollCausesScale = false,
    Offset trackpadScrollToScaleFactor = kDefaultTrackpadScrollToScaleFactor,
    Set<PointerDeviceKind>? supportedDevices,
  }) {
    return GestureDetector(
      key: key,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTap: onTap,
      onTapCancel: onTapCancel,
      onSecondaryTap: onSecondaryTap,
      onSecondaryTapDown: onSecondaryTapDown,
      onSecondaryTapUp: onSecondaryTapUp,
      onSecondaryTapCancel: onSecondaryTapCancel,
      onTertiaryTapDown: onTertiaryTapDown,
      onTertiaryTapUp: onTertiaryTapUp,
      onTertiaryTapCancel: onTertiaryTapCancel,
      onDoubleTapDown: onDoubleTapDown,
      onDoubleTap: onDoubleTap,
      onDoubleTapCancel: onDoubleTapCancel,
      onLongPressDown: onLongPressDown,
      onLongPressCancel: onLongPressCancel,
      onLongPress: onLongPress,
      onLongPressStart: onLongPressStart,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      onLongPressUp: onLongPressUp,
      onLongPressEnd: onLongPressEnd,
      onSecondaryLongPressDown: onSecondaryLongPressDown,
      onSecondaryLongPressCancel: onSecondaryLongPressCancel,
      onSecondaryLongPress: onSecondaryLongPress,
      onSecondaryLongPressStart: onSecondaryLongPressStart,
      onSecondaryLongPressMoveUpdate: onSecondaryLongPressMoveUpdate,
      onSecondaryLongPressUp: onSecondaryLongPressUp,
      onSecondaryLongPressEnd: onSecondaryLongPressEnd,
      onTertiaryLongPressDown: onTertiaryLongPressDown,
      onTertiaryLongPressCancel: onTertiaryLongPressCancel,
      onTertiaryLongPress: onTertiaryLongPress,
      onTertiaryLongPressStart: onTertiaryLongPressStart,
      onTertiaryLongPressMoveUpdate: onTertiaryLongPressMoveUpdate,
      onTertiaryLongPressUp: onTertiaryLongPressUp,
      onTertiaryLongPressEnd: onTertiaryLongPressEnd,
      onVerticalDragDown: onVerticalDragDown,
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      onVerticalDragCancel: onVerticalDragCancel,
      onHorizontalDragDown: onHorizontalDragDown,
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onHorizontalDragCancel: onHorizontalDragCancel,
      onForcePressStart: onForcePressStart,
      onForcePressPeak: onForcePressPeak,
      onForcePressUpdate: onForcePressUpdate,
      onForcePressEnd: onForcePressEnd,
      onPanDown: onPanDown,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onPanCancel: onPanCancel,
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      dragStartBehavior: dragStartBehavior,
      trackpadScrollCausesScale: trackpadScrollCausesScale,
      trackpadScrollToScaleFactor: trackpadScrollToScaleFactor,
      supportedDevices: supportedDevices,
      child: this,
    );
  }

  /// 用Visibility包裹当前组件
  Widget visibility(
    bool visible, {
    Key? key,
    Widget replacement = const SizedBox.shrink(),
    bool maintainState = false,
    bool maintainAnimation = false,
    bool maintainSize = false,
    bool maintainSemantics = false,
    bool maintainInteractivity = false,
  }) {
    return Visibility(
      replacement: replacement,
      visible: visible,
      maintainState: maintainState,
      maintainAnimation: maintainAnimation,
      maintainSize: maintainSize,
      maintainSemantics: maintainSemantics,
      maintainInteractivity: maintainInteractivity,
      child: this,
    );
  }

  /// 用Offstage包裹当前组件
  Widget offstage(bool offstage, {Key? key}) {
    return Offstage(
      key: key,
      offstage: offstage,
      child: this,
    );
  }

  /// 用ColoredBox包裹当前组件
  Widget coloredBox(Color color, {Key? key}) {
    return ColoredBox(
      color: color,
      key: key,
      child: this,
    );
  }

  /// 用Padding包裹当前组件
  Widget padding(
    EdgeInsetsGeometry padding, {
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: padding,
      child: this,
    );
  }

  /// 用Padding包裹当前组件
  Widget margin(
    EdgeInsetsGeometry margin, {
    Key? key,
  }) {
    return padding(margin, key: key);
  }

  ///用Align包裹当前组件
  Widget align({
    AlignmentGeometry alignment = Alignment.center,
    Key? key,
    double? widthFactor,
    double? heightFactor,
  }) {
    return Align(
        key: key,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
        child: this);
  }

  ///用Center包裹当前组件
  Widget center({
    Key? key,
    AlignmentGeometry alignment = Alignment.center,
    double? widthFactor,
    double? heightFactor,
  }) {
    return align(
        alignment: alignment,
        key: key,
        widthFactor: widthFactor,
        heightFactor: heightFactor);
  }

  ///用Container包裹当前组件
  Widget container({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
      key: key,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  ///用DecoratedBox包裹当前组件
  Widget decoratedBox(
    Decoration decoration, {
    Key? key,
    DecorationPosition position = DecorationPosition.background,
  }) {
    return DecoratedBox(
      decoration: decoration,
      key: key,
      position: position,
      child: this,
    );
  }

  ///用ConstrainedBox包裹当前组件
  Widget constrainedBox(
    BoxConstraints constraints, {
    Key? key,
  }) {
    return ConstrainedBox(
      key: key,
      constraints: constraints,
      child: this,
    );
  }

  ///用Opacity包裹当前组件
  Widget opacity(double opacity,
      {Key? key, bool alwaysIncludeSemantics = false}) {
    return Opacity(
      key: key,
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: this,
    );
  }

  ///用Positioned包裹当前组件
  Widget positioned({
    Key? key,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return Positioned(
      key: key,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: this,
    );
  }

  ///用Expanded包裹当前组件
  Widget expanded(
    int flex, {
    Key? key,
  }) {
    return Expanded(
      key: key,
      flex: flex,
      child: this,
    );
  }

  ///用IgnorePointer包裹当前组件
  Widget ignorePointer({
    Key? key,
    bool ignoring = true,
  }) {
    return IgnorePointer(key: key, ignoring: ignoring, child: this);
  }

  ///用AbsorbPointer包裹当前组件
  Widget absorbPointer({
    Key? key,
    bool absorbing = true,
  }) {
    return AbsorbPointer(
      key: key,
      absorbing: absorbing,
      child: this,
    );
  }

  Widget sizedBox({Key? key, double? width, double? height}) {
    return SizedBox(
      key: key,
      width: width,
      height: height,
      child: this,
    );
  }
}

extension WidgetsChainExt<T extends Widget> on List<T> {
  /// 包裹当前组件
  Widget enfold(Widget Function(List<T> children) builder) {
    return builder(this);
  }

  Widget flex({
    Key? key,
    required Axis direction,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline?
        textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    Clip clipBehavior = Clip.none,
  }) {
    return Flex(
      key: key,
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      children: this,
    );
  }

  Widget row({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline?
        textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    Clip clipBehavior = Clip.none,
  }) {
    return flex(
        direction: Axis.horizontal,
        key: key,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        clipBehavior: clipBehavior);
  }

  Widget column({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline?
        textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    Clip clipBehavior = Clip.none,
  }) {
    return flex(
        direction: Axis.vertical,
        key: key,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        clipBehavior: clipBehavior);
  }

  Widget stack({
    Key? key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return Stack(
      key: key,
      alignment: alignment,
      textDirection: textDirection,
      fit: fit,
      clipBehavior: clipBehavior,
      children: this,
    );
  }
}
