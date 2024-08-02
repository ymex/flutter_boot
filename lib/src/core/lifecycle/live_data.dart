import 'package:flutter/foundation.dart';

import 'live_data_scope.dart';

typedef LiveDataCallBack<T> = void Function(T v);

/// 状态值
class LiveData<T> extends ChangeNotifier implements ValueListenable<T> {
  //赋值即更新（注意：改变对象字段无效）
  final bool _notify;
  T _value;

  /// 需要手动调用 liveData.dispose() 销毁
  LiveData.useState(this._value, {bool notify = false, LiveDataScope? scope})
      : _notify = notify {
    if (scope != null) {
      scope.addLiveData(this);
    }
    if (notify) {
      notifyListeners();
    }
  }

  bool hostDispose = false;

  @override
  T get value => _value;

  set value(T value) {
    if (_value == value) {
      return;
    }
    _value = value;
    if (_notify) {
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
