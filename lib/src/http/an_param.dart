enum ParamType { form, body, query, path, header }

/// 请求参数封装，简化请求
class Param {
  String _url = "";

  String get url {
    return _url;
  }

  final Map<String, String> _headerMap = <String, String>{};
  final Map<String, dynamic> _pathMap = <String, dynamic>{};
  final Map<String, dynamic> _queryMap = <String, dynamic>{};
  final Map<String, dynamic> _formMap = <String, dynamic>{};
  final Map<String, dynamic> _bodyMap = <String, dynamic>{};


  Param.url(this._url);

  Param.stream();

  Map<String, String>? headerMap() {
    if (_headerMap.isEmpty) return null;
    return _headerMap;
  }

  Map<String, dynamic>? pathMap() {
    if (_pathMap.isEmpty) return null;
    return _pathMap;
  }

  Map<String, dynamic>? queryMap() {
    if (_queryMap.isEmpty) return null;
    return _queryMap;
  }

  Map<String, dynamic>? formMap() {
    if (_formMap.isEmpty) return null;
    return _formMap;
  }

  Map<String, dynamic>? bodyMap() {
    if (_bodyMap.isEmpty) return null;
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


  /// 合并 Param 参数
  Param merge(Param? param) {
    if (param == null) {
      return this;
    }
    param.headerMap()?.forEach((key, value) {
      _headerMap[key] = value;
    });
    param.pathMap()?.forEach((key, value) {
      _pathMap[key] = value;
    });
    param.queryMap()?.forEach((key, value) {
      _queryMap[key] = value;
    });
    param.formMap()?.forEach((key, value) {
      _formMap[key] = value;
    });
    param.bodyMap()?.forEach((key, value) {
      _bodyMap[key] = value;
    });
    return this;
  }

  /// 合并 map参数
  Param mergeMap(
      {Map<String, dynamic>? paramMap, ParamType type = ParamType.body}) {
    switch (type) {
      case ParamType.body:
        paramMap?.forEach((key, value) {
          _bodyMap[key] = value;
        });

        break;
      case ParamType.query:
        paramMap?.forEach((key, value) {
          _queryMap[key] = value;
        });

        break;
      case ParamType.form:
        paramMap?.forEach((key, value) {
          _formMap[key] = value;
        });

        break;
      case ParamType.path:
        paramMap?.forEach((key, value) {
          _pathMap[key] = value;
        });

        break;
      case ParamType.header:
        paramMap?.forEach((key, value) {
          _headerMap[key] = value;
        });
        break;
      default:
    }
    return this;
  }

}
