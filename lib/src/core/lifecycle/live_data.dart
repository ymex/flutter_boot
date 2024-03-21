part of '../view_model.dart';

typedef LiveDataCallBack<T> = void Function(T v);

/// 状态值
class LiveData<T> extends ChangeNotifier implements ValueListenable<T> {
  //赋值即更新（注意：改变对象字段无效）
  bool _notify = false;
  T _state;

  LiveData._(
    this._state, {
    bool notify = false,
  }) : _notify = notify {
    if (_notify) {
      notifyListeners();
    }
  }

  LiveData.ref(this._state, {bool notify = false}) {
    if (notify) {
      notifyListeners();
    }
  }

  bool hostDispose = false;

  @override
  T get value => _state;

  T get state => _state;

  set state(T value) {
    if (_state == value) {
      return;
    }
    _state = value;
    if(_notify){
      notifyListeners();
    }
  }


  /// 通知更新
  void setState(LiveDataCallBack<T> fn, {bool notify = true}) {
    if (hostDispose) {
      return;
    }
    fn(value);
    if (notify) {
      this.notifyListeners();
    }
  }

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
