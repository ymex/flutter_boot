import 'package:json_annotation/json_annotation.dart';

part 'bili_bili_record.g.dart';
@JsonSerializable(genericArgumentFactories: true)
class BiliBiliRecord {
  String title = "";
  String cover = "";
  String reason = "";
  String url = "";


  BiliBiliRecord();

  factory BiliBiliRecord.fromJson(Map<String, dynamic> json) => _$BiliBiliRecordFromJson(json);

  Map<String, dynamic> toJson() => _$BiliBiliRecordToJson(this);
}