import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boot/src/lifecycle/view_model.dart';
import 'package:flutter_boot/src/http/an_http.dart';
import 'package:flutter_boot/src/http/an_param.dart';

mixin ViewModelScope<T extends StatefulWidget> on State<T> {
  late List<ViewModelState> _notifiers;

  @override
  void initState() {
    _viewModelScopeInitState();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  /// 关闭页面后，请求取消。
  @override
  void dispose() {
    _viewModelScopeDispose();
    super.dispose();
  }

  /// 通知事件 用于 view model 主动调用。
  /// message 消息说明,相当于注释吧。
  /// what 可自定义消息标记
  /// data 携带的数据
  void onNotify(String message, {int? what, Object? data}) {}

  FutureOr<void> onRendered(BuildContext context) {}
}

extension ViewModelScopeExtension on ViewModelScope {
  void _viewModelScopeInitState() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) onRendered(context);
      },
    );
    _notifiers = [];
  }

  void _viewModelScopeDispose() {
    for (var element in _notifiers) {
      element.hostDispose = true;
    }
    _notifiers.clear();
  }

  //管理
  void putViewModelStateNotifier(ViewModelState valueNotifier) {
    _notifiers.add(valueNotifier);
  }
}

/// 用于请求管理，当页面关闭时结束 请求
mixin AnHttpViewModelScope<T extends StatefulWidget> on State<T>
    implements ViewModelScope<T> {
  @override
  late List<ViewModelState> _notifiers;
  late List<CancelToken> _httpRequestTokens;

  @override
  void onNotify(String message, {int? what, Object? data}) {}

  @override
  void initState() {
    _viewModelScopeInitState();
    _anHttpScopeInitState();
    super.initState();
  }

  /// 关闭页面后，请求取消。
  @override
  void dispose() {
    _viewModelScopeDispose();
    _anHttpScopeDispose();
    super.dispose();
  }

  @override
  FutureOr<void> onRendered(BuildContext context) {}
}

/////////////////////////////////////////extension//////////////////////////////

extension AnHttpViewModelScopeExtension on AnHttpViewModelScope {
  void _anHttpScopeInitState() {
    _httpRequestTokens = [];
  }

  void _anHttpScopeDispose() {
    for (var element in _httpRequestTokens) {
      if (!element.isCancelled) {
        element.cancel();
      }
    }
    _httpRequestTokens.clear();
  }

  void putHttpRequestToken(CancelToken cancelToken) {
    _httpRequestTokens.add(cancelToken);
  }

  /// dio 原始返回类型 请求
  Future<Response<T>> anHttpRaw<T>(Param param,
      {HttpMethodType method = HttpMethodType.post,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) {
    var cancelToken = HttpRequestToken();
    putHttpRequestToken(cancelToken);

    return AnHttp.anHttpRaw<T>(param,
        method: method,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);

    // return AnHttp.instance
    //     .request<T>(param, method: method, cancelToken: cancelToken);
  }

  /// http请求， 用于返回值是Object的请求。
  /// convert 数据类型转换器。
  Future<T> anHttp<T>(Param param,
      {required JsonObjectConvertor<T> convertor,
      HttpMethodType method = HttpMethodType.post,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    var cancelToken = HttpRequestToken();
    putHttpRequestToken(cancelToken);

    var response = await AnHttp.anHttpRaw<Map<String, dynamic>>(param,
        method: method,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);

    // var response = await AnHttp.instance.request<Map<String, dynamic>>(param,
    //     method: method, cancelToken: cancelToken);

    return convertor(response.data!);
  }

  /// http请求， 用于返回值是数组的请求。
  /// convert 数据类型转换器。
  Future<List<T>> anHttpArray<T>(
    Param param, {
    required JsonArrayConvertor<T> convertor,
    HttpMethodType method = HttpMethodType.post,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    var cancelToken = HttpRequestToken();
    putHttpRequestToken(cancelToken);
    // var response = await AnHttp.instance.request<List<dynamic>>(param,
    //     method: method, cancelToken: cancelToken);
    var response = await AnHttp.anHttpRaw<List<dynamic>>(param,
        method: method,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    return convertor(response.data!);
  }
}
