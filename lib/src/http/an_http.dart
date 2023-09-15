import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'an_param.dart';

class HttpRequestToken extends CancelToken {}

enum HttpMethodType {
  get,
  post,
  put,
  delete,
  patch,
  head,
}

typedef ResponseConvert<T> = T Function(Response<Map<String, dynamic>> value);
typedef JsonObjectConvertor<T> = T Function(Map<String, dynamic> value);
typedef JsonArrayConvertor<T> = List<T> Function(List<dynamic> value);

/// 封装 Dio 用于http网络请求
class AnHttp {
  /// 连接超时时间 单位：秒
  static const _connectTimeout = Duration(seconds: 60);

  /// 响应超时时间 单位：秒
  static const _receiveTimeout = Duration(seconds: 60);
  late Dio _dio;

  late ResponseConvert? responseConvert;

  AnHttp._() {
    _initDio();
  }

  static final AnHttp _instance = AnHttp._();

  static AnHttp get instance => _instance;

  Dio dio() => instance._dio;

  void _initDio() {
    BaseOptions options = BaseOptions(
        connectTimeout: _connectTimeout, receiveTimeout: _receiveTimeout);
    _dio = Dio(options);
    // 日志打印
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
          responseHeader: false, requestBody: true, responseBody: true));
    }
  }

  /// 网络请求
  /// [method]请求方法类型，默认为post, 当发起请求后要中断本次请求可使用[cancelToken]来终止。
  /// [onSendProgress] 请求进度
  /// [onReceiveProgress] 响应进度
  Future<Response<T>> request<T>(Param param,
      {HttpMethodType method = HttpMethodType.post,
      HttpRequestToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) {
    // formMap  bodyMap
    FormData? formData;
    var formMap = param.formMap();
    if (formMap != null) {
      param.bodyMap()?.forEach((key, value) {
        formMap[key] = value;
      });
      formData = FormData.fromMap(formMap);
    }
    var dataParam = formData ?? param.bodyMap();
    // headerMap
    var headerMap = param.headerMap();
    var option = checkOptions(_httpMethod(method), null);
    option.headers = headerMap;
    //pathMap
    var url = param.url;
    param.pathMap()?.forEach((key, value) {
      url = url.replaceFirst("{$key}", value);
    });
    // var cancelToken = CancelToken();
    // handle?.put(cancelToken);
    return _dio.request<T>(url,
        data: dataParam,
        queryParameters: param.queryMap(),
        options: option,
        cancelToken: cancelToken);
  }

  static Options checkOptions(String method, Options? options) {
    options ??= Options();
    options.method = method;
    return options;
  }

  String _httpMethod(HttpMethodType method) {
    switch (method) {
      case HttpMethodType.post:
        return "POST";
      case HttpMethodType.get:
        return "GET";
      case HttpMethodType.put:
        return "PUT";
      case HttpMethodType.delete:
        return "delete";
      case HttpMethodType.patch:
        return "PATCH";
      case HttpMethodType.head:
        return "HEAD";
      default:
        return "POST";
    }
  }

  /// dio 原始返回类型 请求
  static Future<Response<T>> anHttpRaw<T>(Param param,
      {HttpMethodType method = HttpMethodType.post,
      HttpRequestToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) {
    return AnHttp.instance.request<T>(param,
        method: method,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onSendProgress);
  }

  /// http请求， 用于返回值是Object的请求。
  /// convert 数据类型转换器。
  static Future<T> anHttp<T>(Param param,
      {required JsonObjectConvertor<T> convertor,
      HttpMethodType method = HttpMethodType.post,
      HttpRequestToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    var response = await AnHttp.instance.request<Map<String, dynamic>>(param,
        method: method,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onSendProgress);
    return convertor(response.data!);
  }

  /// http请求， 用于返回值是数组的请求。
  /// convert 数据类型转换器。
  static Future<List<T>> anHttpArray<T>(Param param,
      {required JsonArrayConvertor<T> convertor,
      HttpMethodType method = HttpMethodType.post,
      HttpRequestToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    var response = await AnHttp.instance.request<List<dynamic>>(param,
        method: method,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onSendProgress);
    return convertor(response.data!);
  }
}
