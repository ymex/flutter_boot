import 'dart:ui';

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

extension TypeObjectExt on Object {
  void let<T>(void Function(T v) block) {
    block(this as T);
  }
}

extension TypeDateTimeExt on DateTime {
  String _paddingZero(int num) {
    var v = num.abs();
    if (v < 10) {
      return num >= 0 ? '0$v' : '-0$v';
    }
    return "$num";
  }

  /// 格式化 yyyy-MM-dd HH:mm:ss
  /// yyyy年
  /// MM月 补0
  /// dd日 补0
  /// HH时 补0
  /// mm分 补0
  /// ss秒 补0
  String format([String pattern = "yyyy-MM-dd HH:mm:ss"]) {
    if (pattern.contains("yyyy")) {
      pattern = pattern.replaceFirst("yyyy", "$year");
    }
    if (pattern.contains("MM")) {
      // pattern = pattern.replaceFirst("MM",nf.format(month));
      pattern = pattern.replaceFirst("MM", _paddingZero(month));
    }
    if (pattern.contains("dd")) {
      pattern = pattern.replaceFirst("dd", _paddingZero(day));
    }
    if (pattern.contains("HH")) {
      pattern = pattern.replaceFirst("HH", _paddingZero(hour));
    }
    if (pattern.contains("mm")) {
      pattern = pattern.replaceFirst("mm", _paddingZero(minute));
    }
    if (pattern.contains("ss")) {
      pattern = pattern.replaceFirst("ss", _paddingZero(second));
    }
    return pattern;
  }

  String formatDate([String pattern = "yyyy-MM-dd"]) {
    return format(pattern);
  }

  String formatTime([String pattern = "HH:mm:ss"]) {
    return format(pattern);
  }

  /// 当前月份的开始日期与结束日期
  (DateTime, DateTime) monthRange() {
    var startMonth = DateTime(year, month, 1);
    var endMonth =
        DateTime(year, month + 1, 1).subtract(const Duration(days: 1));
    return (startMonth, endMonth);
  }
}

extension TypeNumExt on num {
  String paddingZero({int width = 2}) {
    return toString().padLeft(width, "0");
  }
}

extension TypeIntExt on int {
  /// 秒转为DateTime
  /// 默认为秒 转 DateTime ，若为 Millisecond 时  rate 设置为 1
  DateTime toDateTime({int rate = 1000}) {
    return DateTime.fromMillisecondsSinceEpoch(this * rate);
  }

  ///转为颜色
  Color get color => Color(this);
}

extension TypeBoolExt on bool {
  T truth<T>(T tv, T fv) {
    if (this) {
      return tv;
    }
    return fv;
  }
}

int _getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return int.parse(hexColor, radix: 16);
}

extension TypeStringExt on String {
  ///转为颜色
  Color get color => _getColorFromHex(this).color;
}
