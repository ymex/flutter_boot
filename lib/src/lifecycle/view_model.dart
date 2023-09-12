import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../http/an_http.dart';
import '../http/an_param.dart';
import 'view_model_scope.dart';

typedef ViewModelStateCallBack<T> = void Function(T value);

class ViewModelState<T> extends ChangeNotifier implements ValueListenable<T> {
  ViewModelState._(this._value, {bool notify = false}) {
    if (notify) {
      notifyListeners();
    }
  }

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
  void _setState<V>(ViewModelStateCallBack<V> fn) {
    if (hostDispose) {
      return;
    }
    fn(value as V);
    super.notifyListeners();
  }

  /// 不建议直接调用。请使用 ViewModel setState()方法。
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

/// Live ViewModel
class LiveViewModel<S extends ViewModelScope> {
  /// 所持有的视图层
  final S _scope;

  LiveViewModel(this._scope);

  /// 创建 ViewModelState
  ViewModelState<T> createState<T>(T value, {bool notify = false}) {
    var valueNotifier = ViewModelState._(value, notify: notify);
    _scope.putViewModelStateNotifier(valueNotifier);
    return valueNotifier;
  }

  void setScopeState(VoidCallback fn) {
    _scope.setState(fn);
  }

  void setState<T>(ViewModelState valueNotifier, ViewModelStateCallBack<T> fn) {
    valueNotifier._setState<T>(fn);
  }

  void sendNotify(String message, {int? what, Object? data}) {
    _scope.onNotify(message, what: what, data: data);
  }
}

class HttpViewModel<S extends AnHttpViewModelScope> extends LiveViewModel<S> {
  HttpViewModel(S scope) : super(scope);

  Future<Response<T>> anHttpRaw<T>(Param param,
      {HttpMethodType method = HttpMethodType.post}) {
    return _scope.anHttpRaw(param, method: method);
  }

  Future<T> anHttp<T>(Param param,
      {required JsonObjectConvertor<T> convertor,
      HttpMethodType method = HttpMethodType.post}) async {
    return _scope.anHttp(param, method: method, convertor: convertor);
  }

  Future<List<T>> anHttpArray<T>(Param param,
      {required JsonArrayConvertor<T> convertor,
      HttpMethodType method = HttpMethodType.post}) async {
    return _scope.anHttpArray(param, method: method, convertor: convertor);
  }
}
