import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_boot/boot.dart';
import 'package:flutter_boot/http.dart';
import 'package:flutter_boot/widget.dart';

part 'action_view_model.dart';
part 'channel/event_bus_mixin.dart';
part 'http_view_model.dart';

mixin ViewModelStateScope<T extends StatefulWidget> on State<T> {
  final List<ViewModel> _viewModels = [];

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

  OverlayTier? _toastTier;
  OverlayTier? _loadingTier;

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
        _initActionVm(vm);
      }
      if (vm is EventBusVmMixin) {
        _initEventBusVm(vm);
      }
    }

    super.initState();
    _toastTier = OverlayTier();
    _loadingTier = OverlayTier();
  }

  void _initActionVm(ActionVmMixin vm) {
    vm._toastCall = this.toast;
    vm._showLoadingCall = this.showLoading;
    vm._dismissLoadingCall = this.dismissLoading;
  }

  void _initEventBusVm(EventBusVmMixin vm) {
    vm._eventBus = vm.useEventBus();
    vm._eventPairs = vm.useEvents();
    if (vm._eventBus != null &&
        vm._eventPairs != null &&
        vm._eventPairs!.isNotEmpty) {
      vm._registerEvents();
    }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  /// 关闭页面后，请求取消。
  @override
  void dispose() {
    var vms = _viewModels;
    for (var vm in vms) {
      for (var liveDataItem in vm.liveDataList) {
        liveDataItem.hostDispose = true;
        liveDataItem.dispose();
      }
      vm.liveDataList.clear();
      if (vm is HttpVmMixin) {
        _disposeHttpVm(vm);
      }
      if (vm is EventBusVmMixin) {
        _disposeEventBusVm(vm);
      }
    }
    super.dispose();

    _toastTier?.dismiss();
    _loadingTier?.dismiss();
    _toastTier = null;
    _loadingTier = null;
  }

  void _disposeHttpVm(HttpVmMixin vm) {
    for (var tokeItem in vm.httpRequestTokens) {
      if (!tokeItem.isCancelled) {
        tokeItem.cancel();
      }
    }
    vm.httpRequestTokens.clear();
  }

  void _disposeEventBusVm(EventBusVmMixin vm) {
    vm._unregisterEvents();
  }

  FutureOr<void> onRendered(BuildContext context) {}

  /// 通知事件 用于 view model 主动调用。
  /// message 消息说明,相当于注释吧。
  /// what 可自定义消息标记
  /// data 携带的数据
  void onNotify(String message, {int? what, Object? data}) {}

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
