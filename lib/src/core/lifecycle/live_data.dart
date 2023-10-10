part of '../view_model.dart';

/// ov 上一次的值
typedef LiveDataCallBack<T> = void Function(T ov);

/// 状态值
class LiveData<T> extends ChangeNotifier implements ValueListenable<T> {
  LiveData._(
    this._value, {
    bool notify = false,
  }) {
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
  void _setState<V>(LiveDataCallBack<V> fn, {bool notify = true}) {
    if (hostDispose) {
      return;
    }
    fn(value as V);
    if (notify) {
      this.notifyListeners();
    }
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
