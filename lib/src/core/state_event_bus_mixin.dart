import 'package:flutter/cupertino.dart';

import 'channel/event_bus.dart';
import 'view_model.dart';

mixin EventBusStateMixin<T extends StatefulWidget> on State<T> {
  EventBus? eventBus;
  List<MethodPair<VoidValueCallback>>? eventPairs;

  EventBus useEventBus() {
    return globalBus;
  }

  List<MethodPair<VoidValueCallback>>? useEvents() {
    return null;
  }

  @override
  void initState() {
    super.initState();
    eventBus = useEventBus();
    eventPairs = useEvents();
    if (eventBus != null && eventPairs != null && eventPairs!.isNotEmpty) {
      _registerEvents();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _unregisterEvents();
  }

  /// 注册
  void _registerEvents() {
    eventPairs?.forEach((pair) {
      eventBus?.register(pair.key, pair.value);
    });
  }

  /// 卸载
  void _unregisterEvents() {
    eventPairs?.forEach((pair) {
      eventBus?.unregister(pair.key, pair.value);
    });
  }
}

mixin EventBusVmMixin on ViewModel {
  EventBus? eventBus;
  List<MethodPair<VoidValueCallback>>? eventPairs;

  EventBus useEventBus() {
    return globalBus;
  }

  List<MethodPair<VoidValueCallback>>? useEvents() {
    return null;
  }

  /// 注册
  void registerEvents() {
    eventPairs?.forEach((pair) {
      eventBus?.register(pair.key, pair.value);
    });
  }

  /// 卸载
  void unregisterEvents() {
    eventPairs?.forEach((pair) {
      eventBus?.unregister(pair.key, pair.value);
    });
  }

  /// 全局广播
  /// 默认：globalBus.emit() 效果相同
  void emitEvent(Object eventName, [Object? arg]) {
    eventBus?.emit(eventName, arg);
  }
}
