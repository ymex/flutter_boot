import 'dart:async';

import "package:flutter/widgets.dart";
import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/http.dart';
import 'package:flutter_boot/kits.dart';
import 'package:flutter_boot/widget.dart';

mixin BootStateScope<T extends StatefulWidget> on State<T> {
  final List<LiveData> _liveDataList = [];
  final List<ViewModel> _viewModels = [];
  final Map<MethodPair<VoidValueCallback>, EventBus> eventMap = {};

  OverlayAction? _overlayAction;

  LiveData<H> useLiveData<H>(H value, [bool notify = false]) {
    var lv = LiveData.useState(value, null, notify);
    if (!_liveDataList.contains(lv)) {
      _liveDataList.add(lv);
    }
    return lv;
  }

  H useViewModel<H extends ViewModel>(H vm) {
    if (!_viewModels.contains(vm)) {
      _viewModels.add(vm);
    }
    return vm;
  }

  MethodPair<VoidValueCallback> useEventBus(MethodPair<VoidValueCallback> event,
      {EventBus? bus}) {
    eventMap[event] = bus ?? globalBus;
    return event;
  }

  @override
  void initState() {
    super.initState();
    _overlayAction = OverlayAction(context);


    for (var event in eventMap.entries) {
      event.value.register(event.key.key, event.key.value);
    }

    for (var ld in _liveDataList) {
      ld.create();
    }

    for (var vm in _viewModels) {
      vm.create();
      vm.setInvokingFun(stateCall: setState, notifyCall: onNotify);

      if (vm is OverlayActionMixin) {
        (vm as OverlayActionMixin).setOverlayAction(_overlayAction);
      }
      if (vm is EventBusMixin) {
        (vm as EventBusMixin).registerEvents();
        ;
      }
    }
    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) onRendered(context);
      },
    );
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

    for (var event in eventMap.entries) {
      event.value.unregister(event.key.key, event.key.value);
    }

    for (var ld in _liveDataList) {
      ld.destroy();
    }

    for (var vm in _viewModels) {
      vm.destroy();
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
    _liveDataList.clear();
    super.dispose();
  }

  bool autoDispose() {
    return true;
  }

  Future onRendered(BuildContext context) async {}

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

abstract class BootState<T extends StatefulWidget> extends State<T>
    with BootStateScope {}
