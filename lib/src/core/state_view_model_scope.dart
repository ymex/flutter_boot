import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/http.dart';
import 'package:flutter_boot/kits.dart';
import 'package:flutter_boot/widget.dart';

// part 'view_model_http.dart';

mixin ViewModelStateScope<T extends StatefulWidget> on State<T> {
  final List<ViewModel> _viewModels = [];
  OverlayTier? _toastTier;
  OverlayTier? _loadingTier;
  bool _isInitArg = false;

  /// 获取指定的ViewModel
  V getViewModel<V extends ViewModel>({int index = 0}) {
    return _viewModels[index] as V;
  }

  void vm<V extends ViewModel>({int index = 0, Function(V v)? block}) {
    if (block != null && index >= 0 && index < _viewModels.length) {
      block(getViewModel(index: index));
    }
  }

  /// 初始化 ViewModel
  /// ViewModel 仅初始化一次。
  List<ViewModel> useViewModels() {
    return [];
  }

  @override
  void initState() {
    _viewModels.clear();
    _viewModels.addAll(useViewModels());

    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) onRendered(context);
      },
    );

    var vms = _viewModels;
    for (var vm in vms) {
      vm.stateCall = this.setState;
      vm.notifyCall = this.onNotify;
      if (vm is ActionVmMixin) {
        _initActionVm(vm as ActionVmMixin);
      }
      if (vm is EventBusVmMixin) {
        _initEventBusVm(vm);
      }
    }

    super.initState();
    _toastTier = OverlayTier();
    _loadingTier = OverlayTier();
  }

  /// 首先要在build 方法中调用 parseArguments。
  /// 只会调用一次
  /// arg 路由传递的参数
  void onParseArguments(Object? args) {}

  /// 须在build主动调用、
  /// 关于主动调用的原因：父类build方法没找到合适的方式自动调用

  void parseArguments() {
    if (!_isInitArg) {
      _isInitArg = true;
      onParseArguments(context.arguments);
    }
  }

  void _initActionVm(ActionVmMixin vm) {
    vm.toastCall = this.toast;
    vm.showLoadingCall = this.showLoading;
    vm.dismissLoadingCall = this.dismissLoading;
  }

  void _initEventBusVm(EventBusVmMixin vm) {
    vm.eventBus = vm.useEventBus();
    vm.eventPairs = vm.useEvents();
    if (vm.eventBus != null &&
        vm.eventPairs != null &&
        vm.eventPairs!.isNotEmpty) {
      vm.registerEvents();
    }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  /// 关闭页面后，请求取消。
  @override
  void dispose() {
    logI("--------------------------view model state dispose");
    if (!autoDispose()) {
      super.dispose();
      return;
    }
    destroy();
    super.dispose();
  }

  bool autoDispose() {
    return true;
  }

  void destroy() {
    var vms = _viewModels;
    for (var vm in vms) {
      vm.dispose();
      if (vm is AnHttpMixin) {
        (vm as AnHttpMixin).disposeRequestToken();
      }

      if (vm is EventBusVmMixin) {
        vm.unregisterEvents();
      }
    }
    _viewModels.clear();
    _toastTier?.dismiss();
    _loadingTier?.dismiss();
    _toastTier = null;
    _loadingTier = null;
  }

  FutureOr<void> onRendered(BuildContext context) {}

  /// 通知事件 用于 view model 主动调用。
  /// message 消息说明,相当于注释吧。
  /// what 可自定义消息标记
  /// data 携带的数据
  void onNotify(String message, {int? what, Object? data}) {
    if (message == "_finish_current_page") {
      context.navigator.pop(data);
    }
  }

  void toast(
    String message, {
    int duration = 2,
    ToastAlignment alignment = ToastAlignment.bottom,
    Widget? widget,
  }) {
    _toast(
        message: message,
        duration: duration,
        alignment: alignment,
        widget: widget);
  }

  void showLoading({Widget? widget}) {
    _showLoading(widget);
  }

  void dismissLoading() {
    _dismissLoading();
  }

  void _showLoading(Widget? widget) {
    _loadingTier?.show(context, widget ?? buildDefLoadingOverlay(context),
        replace: false);
  }

  /// toast
  /// [message] 提醒的文字
  /// [duration] 显示的时长，单位秒
  /// [alignment] 显示的位置
  /// [margin] 边距
  void _toast(
      {Widget? widget,
      String? message,
      int duration = 2,
      ToastAlignment alignment = ToastAlignment.bottom}) {
    if (widget == null) {
      var tw = buildDefToastOverlay(context,
          message: message, duration: duration, alignment: alignment);
      _toastWidget(tw, duration: duration);
      return;
    }
    _toastWidget(widget, duration: duration);
  }

  void _toastWidget(Widget widget, {int duration = 2}) {
    _toastTier?.show(context, widget,
        duration: Duration(seconds: duration), opaque: false);
  }

  void _dismissLoading() {
    _loadingTier?.dismiss();
  }
}

abstract class ViewModelState<T extends StatefulWidget> extends State<T>
    with ViewModelStateScope {}
