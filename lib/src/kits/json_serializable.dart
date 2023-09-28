/// 用于 json_serializable 反序列化时的类型转换。
/// @JosnKey(fromJson:anyToString)

/// 转为 String, null 时转为空串
String anyToString(dynamic value) {
  var str = "$value";
  return str == 'null' ? '' : str;
}

/// 转为 int 默认为 0
int anyToInt(dynamic value) {
  var result = int.tryParse("$value");
  return result ?? 0;
}

/// 转为double 默认为 0
double anyToDouble(dynamic value) {
  var result = double.tryParse("$value");
  return result ?? 0;
}

/// 转为 bool 默认为 false
/// 'true' 、'false'、'TRUE' 、'FALSE' 可以转换
bool anyToBool(dynamic value) {
  var result = bool.tryParse("$value", caseSensitive: false);
  return result ?? false;
}
