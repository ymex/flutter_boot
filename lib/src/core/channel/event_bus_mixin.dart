import 'event_bus.dart';

mixin EventBusMixin {
  EventBus? _eventBus;
  List<MethodPair<VoidValueCallback>>? _eventPairs;

  EventBus useBus() {
    return globalBus;
  }

  List<MethodPair<VoidValueCallback>>? useEvents() {
    return null;
  }

  /// 注册
  void registerEvents() {
    _eventBus = useBus();
    _eventPairs = useEvents();
    _eventPairs?.forEach((pair) {
      _eventBus?.register(pair.key, pair.value);
    });
  }

  /// 卸载
  void unregisterEvents() {
    _eventPairs?.forEach((pair) {
      _eventBus?.unregister(pair.key, pair.value);
    });
  }

  /// 全局广播
  /// 默认：globalBus.emit() 效果相同
  void emit(Object eventName, [Object? arg]) {
    _eventBus?.emit(eventName, arg);
  }
}
