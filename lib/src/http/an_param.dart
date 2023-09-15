enum ParamType { form, body, query, path, header }
/// 请求参数封装，简化请求
class Param {
  String _url = "";
  get url {
    return _url;
  }
  final Map<String, dynamic> _formMap = <String, dynamic>{};
  final Map<String, dynamic> _bodyMap = <String, dynamic>{};
  final Map<String, String> _queryMap = <String, String>{};
  final Map<String, String> _pathMap = <String, String>{};
  final Map<String, String> _headerMap = <String, String>{};

  Param.url(this._url);
  // Param.stream();

  Map<String, String>? queryMap(){
    if(_queryMap.isEmpty) return null;
    return _queryMap;
  }

  Map<String, String>? headerMap(){
    if(_headerMap.isEmpty) return null;
    return _headerMap;
  }
  Map<String, String>? pathMap(){
    if(_pathMap.isEmpty) return null;
    return _pathMap;
  }
  Map<String, dynamic>? formMap(){
    if(_formMap.isEmpty) return null;
    return _formMap;
  }
  Map<String, dynamic>? bodyMap(){
    if(_bodyMap.isEmpty) return null;
    return _bodyMap;
  }

  /// 参数绑定
  /// [type]为发起网络请求时，参数所在的载体位置。默认为body 参数。
  Param tie(String key, dynamic value, {ParamType type = ParamType.body}) {
    switch (type) {
      case ParamType.body:
        _bodyMap[key] = value;
        break;
      case ParamType.query:
        _queryMap[key] = value;
        break;
      case ParamType.form:
        _formMap[key] = value;
        break;
      case ParamType.path:
        _pathMap[key] = value;
        break;
      case ParamType.header:
        _headerMap[key] = value;
        break;
      default:
    }

    return this;
  }

  Param common(
      {Map<String, dynamic>? paramCommon, ParamType type = ParamType.body}) {
    switch (type) {
      case ParamType.body:
        paramCommon?.forEach((key, value) {
          _bodyMap[key] = value;
        });

        break;
      case ParamType.query:
        paramCommon?.forEach((key, value) {
          _queryMap[key] = value;
        });

        break;
      case ParamType.form:
        paramCommon?.forEach((key, value) {
          _formMap[key] = value;
        });

        break;
      case ParamType.path:
        paramCommon?.forEach((key, value) {
          _pathMap[key] = value;
        });

        break;
      case ParamType.header:
        paramCommon?.forEach((key, value) {
          _headerMap[key] = value;
        });
        break;
      default:
    }
    return this;
  }

}
