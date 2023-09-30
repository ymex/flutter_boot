import 'package:flutter/foundation.dart';

/// ov 上一次的值
typedef LiveDataCallBack<T> = void Function(T ov);

/// 状态值
class LiveData<T> extends ChangeNotifier implements ValueListenable<T> {
  LiveData._(this._value, {bool notify = false}) {
    if (notify) {
      notifyListeners();
    }
  }

  // LiveData.ref(this._value, {bool notify = false}) {
  //   if (notify) {
  //     notifyListeners();
  //   }
  // }

  bool hostDispose = false;

  @override
  T get value => _value;

  T _value;

  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    // 为增加更新的可控制性，要主动去调用
    // notifyListeners();
  }

  /// 通知更新
  void _setState<V>(LiveDataCallBack<V> fn) {
    if (hostDispose) {
      return;
    }
    fn(value as V);
    this.notifyListeners();
  }

  /// 通知更新
  // void setState<V>(LiveDataCallBack<V> fn) {
  //   if (hostDispose) {
  //     return;
  //   }
  //   fn(value as V);
  //   this.notifyListeners();
  // }

  /// 不建议直接调用。请使用 ViewModel setState()方法。
  @protected
  @override
  void notifyListeners() {
    if (hostDispose) {
      return;
    }
    super.notifyListeners();
  }

  @override
  String toString() => '$this->value:($value)';
}

/// ViewModel
/// 要隐藏 liveData 的构造、_setState 方法，只能把 ViewModel 放到这个文件中。
class ViewModel {
  final List<LiveData> _liveDataList = [];
  Function(VoidCallback)? _stateCall;
  Function(String message, {int? what, Object? data})? notifyCall;

  List<LiveData> get liveDataList => _liveDataList;

  set stateCall(value) => _stateCall = value;

  //管理
  void _putViewModelStateNotifier(LiveData liveData) {
    _liveDataList.add(liveData);
  }

  /// 创建 ViewModelState
  /// notify 创建时是否更新状态
  LiveData<T> useState<T>(T value, {bool notify = false}) {
    var valueNotifier = LiveData._(value, notify: notify);
    _putViewModelStateNotifier(valueNotifier);
    return valueNotifier;
  }

  void setScopeState(VoidCallback fn) {
    if (_stateCall != null) _stateCall!(fn);
  }

  void setState<T>(LiveData liveData, LiveDataCallBack<T> fn) {
    liveData._setState<T>(fn);
  }

  void sendNotify(String message, {int? what, Object? data}) {
    if (notifyCall != null) notifyCall!(message, what: what, data: data);
  }
}
