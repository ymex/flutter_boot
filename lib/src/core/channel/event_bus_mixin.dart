part of '../view_model_state.dart';

mixin EventBusStateMixin<T extends StatefulWidget> on State<T> {
  EventBus? _eventBus;
  List<MethodPair<VoidValueCallback>>? _eventPairs;

  EventBus useEventBus() {
    return globalBus;
  }

  List<MethodPair<VoidValueCallback>>? useEvents() {
    return null;
  }

  @override
  void initState() {
    super.initState();
    _registerEvents();
  }

  @override
  void dispose() {
    super.dispose();
    _unregisterEvents();
  }

  /// 注册
  void _registerEvents() {
    _eventPairs?.forEach((pair) {
      _eventBus?.register(pair.key, pair.value);
    });
  }

  /// 卸载
  void _unregisterEvents() {
    _eventPairs?.forEach((pair) {
      _eventBus?.unregister(pair.key, pair.value);
    });
  }
}

mixin EventBusVmMixin on ViewModel {
  EventBus? _eventBus;
  List<MethodPair<VoidValueCallback>>? _eventPairs;

  EventBus useEventBus() {
    return globalBus;
  }

  List<MethodPair<VoidValueCallback>>? useEvents() {
    return null;
  }

  /// 注册
  void _registerEvents() {
    _eventPairs?.forEach((pair) {
      _eventBus?.register(pair.key, pair.value);
    });
  }

  /// 卸载
  void _unregisterEvents() {
    _eventPairs?.forEach((pair) {
      _eventBus?.unregister(pair.key, pair.value);
    });
  }

  /// 全局广播
  /// 默认：globalBus.emit() 效果相同
  void emitEvent(Object eventName, [Object? arg]) {
    _eventBus?.emit(eventName, arg);
  }
}
