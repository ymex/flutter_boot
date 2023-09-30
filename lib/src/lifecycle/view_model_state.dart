import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_boot/lifecycle.dart';
import 'package:flutter_boot/widget.dart';

mixin ViewModelScope<T extends StatefulWidget> on State<T> {
  final List<ViewModel> _viewModels = [];

  List<ViewModel> get viewModels => _viewModels;

  List<ViewModel> initViewModel() {
    return [];
  }

  OverlayTier? _toastTier;
  OverlayTier? _loadingTier;

  @override
  void initState() {
    _viewModels.clear();
    _viewModels.addAll(initViewModel());

    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) onRendered(context);
      },
    );

    var vms = viewModels;
    for (var vm in vms) {
      vm.stateCall = this.setState;
      vm.notifyCall = this.onNotify;
      if (vm is ActionViewModel) {
        vm.toastCall = this.toast;
        vm.showLoadingCall = this.showLoading;
        vm.dismissLoadingCall = this.dismissLoading;
      }
    }

    super.initState();
    _toastTier = OverlayTier();
    _loadingTier = OverlayTier();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  /// 关闭页面后，请求取消。
  @override
  void dispose() {
    var vms = viewModels;
    for (var vm in vms) {
      for (var liveDataItem in vm.liveDataList) {
        liveDataItem.hostDispose = true;
        liveDataItem.dispose();
      }
      vm.liveDataList.clear();
      if (vm is HttpViewModel) {
        for (var tokeItem in vm.httpRequestTokens) {
          if (!tokeItem.isCancelled) {
            tokeItem.cancel();
          }
        }
        vm.httpRequestTokens.clear();
      }
    }
    super.dispose();
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
    with ViewModelScope {}
