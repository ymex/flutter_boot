import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../http/an_http.dart';
import '../http/an_param.dart';
import 'view_model_scope.dart';

/// 主动状态通知
/// 无法手动创建，仅通过LiveViewModel 的 ModelValue() 方法新建。
class ModelValueNotifier<T> extends ValueNotifier<T> {
  bool hostDispose = false;
  bool unSafe = false;

  ModelValueNotifier._(super.value);

  /// 通知更新
  void _setState<V>(ModelValueCallBack<V> fn) {
    if (hostDispose) {
      return;
    }
    fn(value as V);
    super.notifyListeners();
  }

  /// 不建议直接调用。请使用 ViewModel setModelValueState()方法。
  @override
  void notifyListeners() {
    if(hostDispose){
      return;
    }
    super.notifyListeners();
  }
}

typedef ModelValueCallBack<T> = void Function(T value);

/// Live ViewModel
class LiveViewModel<S extends ViewModelScope> {
  /// 所持有的视图层
  final S _scope;

  LiveViewModel(this._scope);

  /// 创建ModelValueNotifier，这是一个方法，仅看起来像类。
  ModelValueNotifier<T?> ModelValue<T>({T? value}) {
    var valueNotifier = ModelValueNotifier._(value);
    _scope.putModelValueNotifier(valueNotifier);
    return valueNotifier;
  }

  void setState(VoidCallback fn) {
    _scope.setState(fn);
  }

  void setModelValueState<T>(ModelValueNotifier valueNotifier, ModelValueCallBack<T> fn) {
    valueNotifier._setState(fn);
  }

  void onWidgetRendered(){

  }

  /// 组件的state 一般都定义为私有的。只能间接使用，事件通知回调。
  void sendNoticeEvent({int? what, String? message, Object? data}) {
    _scope.onNoticeEvent(what: what, message: message, data: data);
  }
}

/// todo 待思考 ，请求状态 加载中... 加载出错...是否需要。
class HttpViewModel<S extends AnHttpViewModelScope> extends LiveViewModel<S> {
  HttpViewModel(S scope) : super(scope);

  Future<Response<T>> anRawHttp<T>(Param param,
      {HttpMethodType method = HttpMethodType.post}) {
    return _scope.anRawHttp(param, method: method);
  }

  Future<T> anValueHttp<T>(Param param,
      {required JsonObjectConvertor<T> convertor,
      HttpMethodType method = HttpMethodType.post}) async {
    return _scope.anValueHttp(param, method: method, convertor: convertor);
  }

  Future<List<T>> anArrayHttp<T>(Param param,
      {required JsonArrayConvertor<T> convertor,
      HttpMethodType method = HttpMethodType.post}) async {
    return _scope.anArrayHttp(param, method: method, convertor: convertor);
  }
}
