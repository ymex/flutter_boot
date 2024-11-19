import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';

import '../kits/screen/_flutter_widgets.dart';
import '../kits/screen/screen_util.dart';

/*
 * 屏幕适配部分 - 代码来自：flutter_screenutil
 * 使用参考：https://github.com/OpenFlutter/flutter_screenutil/blob/master/README_CN.md
 */

class BootScope extends StatefulWidget {
  const BootScope({
    super.key,
    this.builder,
    this.child,
    this.rebuildFactor = RebuildFactors.size,
    this.designSize = ScreenUtil.defaultSize,
    this.splitScreenMode = false,
    this.minTextAdapt = false,
    this.useInheritedMediaQuery = false,
    this.ensureScreenSize = false,
    this.enableScaleWH,
    this.enableScaleText,
    this.responsiveWidgets,
    this.excludeWidgets,
    this.fontSizeResolver = FontSizeResolvers.width,
  });

  ///一般返回一个MaterialApp类型的Function()
  final ScreenUtilInitBuilder? builder;

  ///builder和child中必须填写至少一项
  final Widget? child;

  ///支持分屏尺寸 默认 false
  final bool splitScreenMode;

  ///是否根据宽度/高度中的最小值适配文字 默认 false
  final bool minTextAdapt;
  final bool useInheritedMediaQuery;
  final bool ensureScreenSize;
  final bool Function()? enableScaleWH;
  final bool Function()? enableScaleText;

  ///返回屏幕指标更改时是否重建。
  final RebuildFactor rebuildFactor;
  final FontSizeResolver fontSizeResolver;

  /// The [Size] of the device in the design draft, in dp
  /// 设计稿中设备的尺寸(单位随意,建议dp,但在使用过程中必须保持一致)
  final Size designSize;
  final Iterable<String>? responsiveWidgets;
  final Iterable<String>? excludeWidgets;

  @override
  State<BootScope> createState() => _BootScopeState();
}

class _BootScopeState extends State<BootScope> with WidgetsBindingObserver {
  final _canMarkedToBuild = HashSet<String>();
  final _excludedWidgets = HashSet<String>();
  MediaQueryData? _mediaQueryData;
  final _binding = WidgetsBinding.instance;
  final _screenSizeCompleter = Completer<void>();

  @override
  void initState() {
    if (widget.responsiveWidgets != null) {
      _canMarkedToBuild.addAll(widget.responsiveWidgets!);
    }

    ScreenUtil.enableScale(
        enableWH: widget.enableScaleWH, enableText: widget.enableScaleText);

    _validateSize().then(_screenSizeCompleter.complete);

    super.initState();
    _binding.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _revalidate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _revalidate();
  }

  MediaQueryData? _newData() {
    final view = View.maybeOf(context);
    if (view != null) return MediaQueryData.fromView(view);
    return null;
  }

  Future<void> _validateSize() async {
    if (widget.ensureScreenSize) return ScreenUtil.ensureScreenSize();
  }

  void _markNeedsBuildIfAllowed(Element el) {
    final widgetName = el.widget.runtimeType.toString();
    if (_excludedWidgets.contains(widgetName)) return;
    final allowed = widget is SU ||
        _canMarkedToBuild.contains(widgetName) ||
        !(widgetName.startsWith('_') || flutterWidgets.contains(widgetName));

    if (allowed) el.markNeedsBuild();
  }

  void _updateTree(Element el) {
    _markNeedsBuildIfAllowed(el);
    el.visitChildren(_updateTree);
  }

  void _revalidate([void Function()? callback]) {
    final oldData = _mediaQueryData;
    final newData = _newData();

    if (newData == null) return;

    if (oldData == null || widget.rebuildFactor(oldData, newData)) {
      setState(() {
        _mediaQueryData = newData;
        _updateTree(context as Element);
        callback?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = _mediaQueryData;

    if (mq == null) return const SizedBox.shrink();

    if (!widget.ensureScreenSize) {
      ScreenUtil.configure(
        data: mq,
        designSize: widget.designSize,
        splitScreenMode: widget.splitScreenMode,
        minTextAdapt: widget.minTextAdapt,
        fontSizeResolver: widget.fontSizeResolver,
      );

      return widget.builder?.call(context, widget.child) ?? widget.child!;
    }

    return FutureBuilder<void>(
      future: _screenSizeCompleter.future,
      builder: (c, snapshot) {
        ScreenUtil.configure(
          data: mq,
          designSize: widget.designSize,
          splitScreenMode: widget.splitScreenMode,
          minTextAdapt: widget.minTextAdapt,
          fontSizeResolver: widget.fontSizeResolver,
        );

        if (snapshot.connectionState == ConnectionState.done) {
          return widget.builder?.call(context, widget.child) ?? widget.child!;
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _binding.removeObserver(this);
    super.dispose();
  }
}
