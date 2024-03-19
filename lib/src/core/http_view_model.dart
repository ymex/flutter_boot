part of "view_model_state.dart";

mixin HttpVmMixin on ViewModel {
  final List<HttpRequestToken> _httpRequestTokens = [];

  List<HttpRequestToken> get httpRequestTokens => _httpRequestTokens;

  void _putHttpRequestToken(HttpRequestToken cancelToken) {
    _httpRequestTokens.add(cancelToken);
  }

  HttpRequestToken getHttpRequestToken([HttpRequestToken? requestToken]) {
    var rt = requestToken ?? DioCancelToken();
    _putHttpRequestToken(rt);
    return rt;
  }

  /// dio 原始返回类型 请求
  Future<Response<T>> anHttp<T>(
    Param param, {
    HttpMethodType method = HttpMethodType.post,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRequestToken? cancelToken,
  }) {
    return AnHttp.anHttp<T>(param,
        method: method,
        cancelToken: getHttpRequestToken(cancelToken),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  /// http请求， 用于返回值是Object的请求。
  /// convert 数据类型转换器。
  Future<T> anHttpJson<T>(
    Param param, {
    required JsonObjectConvertor<T> convertor,
    HttpMethodType method = HttpMethodType.post,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRequestToken? cancelToken,
  }) async {
    var response = await AnHttp.anHttpJson<T>(param,
        convertor: convertor,
        method: method,
        cancelToken: getHttpRequestToken(cancelToken),
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
    HttpRequestToken? cancelToken,
  }) async {
    var response = await AnHttp.anHttpArray<T>(param,
        convertor: convertor,
        cancelToken: getHttpRequestToken(cancelToken),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    return response;
  }
}

class HttpViewModel extends ViewModel with ActionVmMixin, HttpVmMixin {
  HttpViewModel({super.key});
}
