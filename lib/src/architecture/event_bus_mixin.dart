part of "view_model_state.dart";

mixin VmEventBusMixin on ViewModel {
  EventBus? _eventBus;
  List<EventPair>? _eventPairs;

  EventBus useEventBus() {
    return globalBus;
  }

  List<EventPair>? useEvents() {
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
