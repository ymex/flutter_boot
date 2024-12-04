import 'dart:async';

import "package:flutter/widgets.dart";
import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/http.dart';
import 'package:flutter_boot/kits.dart';
import 'package:flutter_boot/widget.dart';

mixin BootStateScope<T extends StatefulWidget> on State<T> {
  final List<Live> _lives = [];
  final List<LiveData> _liveDataList = [];
  final List<ViewModel> _viewModels = [];
  final Map<MethodPair<VoidValueCallback>, EventBus> eventMap = {};

  OverlayAction? _overlayAction;

  H useLive<H extends Live>(H live) {
    if (!_lives.contains(live)) {
      live.create();
      _lives.add(live);
    }
    return live;
  }

  LiveData<H> useLiveState<H>(H value,[bool notify = false]) {
    var liveData = LiveData.useState(value,notify);
    if (!_liveDataList.contains(liveData)) {
      liveData.create();
      _liveDataList.add(liveData);
    }
    return liveData;
  }

  LiveData<H> useLiveData<H>(LiveData<H> liveData) {
    if (!_liveDataList.contains(liveData)) {
      liveData.create();
      _liveDataList.add(liveData);
    }
    return liveData;
  }

  H useViewModel<H extends ViewModel>(H vm) {
    if (!_viewModels.contains(vm)) {
      vm.create();
      vm.setInvokingFun(stateCall: setState, notifyCall: onNotify);

      if (vm is OverlayActionMixin) {
        (vm as OverlayActionMixin).setOverlayAction(_overlayAction);
      }
      if (vm is EventBusMixin) {
        (vm as EventBusMixin).registerEvents();
      }
      _viewModels.add(vm);
    }
    return vm;
  }

  void useEventBus(MethodPair<VoidValueCallback> event,
      {EventBus? bus}) {
    if (!eventMap.containsKey(event)) {
      eventMap[event] = bus ?? globalBus;
      eventMap[event]?.register(event.key, event.value);
    }
  }

  @override
  void initState() {
    super.initState();
    _overlayAction = OverlayAction(context);

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
    for (var live in _lives) {
      live.destroy();
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
