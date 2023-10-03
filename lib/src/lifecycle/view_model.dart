import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot/http.dart';
import 'package:flutter_boot/widget.dart';
import 'package:flutter_boot/lifecycle.dart';

class ActionViewModel extends ViewModel {
  Function(
    String message, {
    int duration,
    ToastAlignment alignment,
    Widget? widget,
  })? toastCall;

  Function({Widget? widget})? showLoadingCall;

  VoidCallback? dismissLoadingCall;

  void toast(
    String message, {
    int duration = 2,
    ToastAlignment alignment = ToastAlignment.bottom,
    Widget? widget,
  }) {
    if (toastCall != null) {
      toastCall!(message,
          duration: duration, alignment: alignment, widget: widget);
    }
  }

  void showLoading({Widget? widget}) {
    if (showLoadingCall != null) {
      showLoadingCall!(widget: widget);
    }
  }

  void dismissLoading() {
    if (dismissLoadingCall != null) {
      dismissLoadingCall!();
    }
  }
}

class HttpViewModel extends ActionViewModel {
  final List<CancelToken> _httpRequestTokens = [];

  List<CancelToken> get httpRequestTokens => _httpRequestTokens;

  void putHttpRequestToken(CancelToken cancelToken) {
    _httpRequestTokens.add(cancelToken);
  }

  /// dio 原始返回类型 请求
  Future<Response<T>> anHttp<T>(Param param,
      {HttpMethodType method = HttpMethodType.post,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) {
    var cancelToken = HttpRequestToken();
    putHttpRequestToken(cancelToken);

    return AnHttp.anHttp<T>(param,
        method: method,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);

    // return AnHttp.instance
    //     .request<T>(param, method: method, cancelToken: cancelToken);
  }

  /// http请求， 用于返回值是Object的请求。
  /// convert 数据类型转换器。
  Future<T> anHttpJson<T>(Param param,
      {required JsonObjectConvertor<T> convertor,
      HttpMethodType method = HttpMethodType.post,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    var cancelToken = HttpRequestToken();
    putHttpRequestToken(cancelToken);

    // var response = await AnHttp.anHttp<Map<String, dynamic>>(param,
    //     method: method,
    //     cancelToken: cancelToken,
    //     onSendProgress: onSendProgress,
    //     onReceiveProgress: onReceiveProgress);

    // var response = await AnHttp.instance.request<Map<String, dynamic>>(param,
    //     method: method, cancelToken: cancelToken);

    // return convertor(response.data!);
    var response = await AnHttp.anHttpJson<T>(param,
        convertor: convertor,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    return response;
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

    // var response = await AnHttp.anHttp<List<dynamic>>(param,
    //     method: method,
    //     cancelToken: cancelToken,
    //     onSendProgress: onSendProgress,
    //     onReceiveProgress: onReceiveProgress);
    // return convertor(response.data!);

    var response = await AnHttp.anHttpArray<T>(param,
        convertor: convertor,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    return response;
  }
}
