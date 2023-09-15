import 'package:flutter_boot/kits.dart';
import 'package:json_annotation/json_annotation.dart';

part 'words.g.dart';
@JsonSerializable(genericArgumentFactories: true)
class Words {
  @JsonKey(name: 'code',fromJson:anyToString)
  late String code;
  String? error;
  late String? cycx;
  late String? cyjs;
  late String? cycc;
  late String? cyzj;
  late String? cybx;
  late String? cysy;

  Words();

  factory Words.fromJson(Map<String, dynamic> json) => _$WordsFromJson(json);

  Map<String, dynamic> toJson() => _$WordsToJson(this);

  @override
  String toString() {
    return 'Words{code: $code, cycx: $cycx, cyjs: $cyjs, cycc: $cycc, cyzj: $cyzj, cybx: $cybx, cysy: $cysy}';
  }
}