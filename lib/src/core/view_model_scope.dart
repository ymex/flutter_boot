import 'dart:async';

import "package:flutter/widgets.dart";
import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/http.dart';
import 'package:flutter_boot/kits.dart';
import 'package:flutter_boot/widget.dart';

mixin ViewModelStateScope<T extends StatefulWidget> on State<T> {
  final List<ViewModel> _viewModels = [];
  bool _isInitArg = false;
  OverlayAction? _overlayAction;

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
    super.initState();
    _overlayAction = OverlayAction(context);
    _viewModels.clear();
    _viewModels.addAll(useViewModels());

    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) onRendered(context);
      },
    );

    var vms = _viewModels;
    for (var vm in vms) {
      vm.setInvokingFun(stateCall: setState, notifyCall: onNotify);
      if (vm is OverlayActionMixin) {
        _initOverlayAction(vm as OverlayActionMixin);
      }
      if (vm is EventBusMixin) {
        _initEventBusVm(vm as EventBusMixin);
      }
    }
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

  void _initEventBusVm(EventBusMixin vm) {
    vm.registerEvents();
  }

  void _initOverlayAction(OverlayActionMixin vm) {
    vm.setOverlayAction(_overlayAction);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  /// 关闭页面后，请求取消。
  @override
  void dispose() {
    if (!autoDispose()) {
      super.dispose();
      return;
    }
    destroyViewModel();
    super.dispose();
  }

  bool autoDispose() {
    return true;
  }

  void destroyViewModel() {
    var vms = _viewModels;
    for (var vm in vms) {
      vm.destroyLiveData();
      if (vm is AnHttpMixin) {
        (vm as AnHttpMixin).disposeRequestToken();
      }
      if (vm is EventBusMixin) {
        (vm as EventBusMixin).unregisterEvents();
      }
      if (vm is OverlayActionMixin) {
        var oa = vm as OverlayActionMixin;
        oa.disposeOverlayAction();
        oa.setOverlayAction(null);
      }
    }
    _viewModels.clear();
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
}

abstract class ViewModelState<T extends StatefulWidget> extends State<T>
    with ViewModelStateScope, LiveDataScope {
  @override
  void dispose() {
    destroyLiveData();
    super.dispose();
  }
}
