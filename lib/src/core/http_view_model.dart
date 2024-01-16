part of "view_model_state.dart";

mixin HttpVmMixin on ViewModel {
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
    var response = await AnHttp.anHttpJson<T>(param,
        convertor: convertor,
        method: method,
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
    var response = await AnHttp.anHttpArray<T>(param,
        convertor: convertor,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    return response;
  }
}

class HttpViewModel extends ViewModel with ActionVmMixin, HttpVmMixin {
  HttpViewModel({super.key});
}
