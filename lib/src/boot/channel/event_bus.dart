import 'package:flutter_boot/boot.dart';

var globalBus = EventBus();

class EventBus {
  //私有构造函数
  EventBus._();

  //保存单例
  static final EventBus _instance = EventBus._();

  //工厂构造函数
  factory EventBus() => _instance;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _eMap = <Object, List<VoidValueCallback>?>{};

  //注册订阅者
  void register(Object eventName, VoidValueCallback f) {
    _eMap[eventName] ??= <VoidValueCallback>[];
    _eMap[eventName]!.add(f);
  }

  //移除订阅者
  void unregister(Object eventName, [VoidValueCallback? f]) {
    var list = _eMap[eventName];
    if (list == null) return;
    if (f == null) {
      _eMap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(Object eventName, [Object? arg]) {
    var list = _eMap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}
