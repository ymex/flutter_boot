// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bili_bili_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BiliBiliRecord _$BiliBiliRecordFromJson(Map<String, dynamic> json) =>
    BiliBiliRecord()
      ..title = json['title'] as String
      ..cover = json['cover'] as String
      ..reason = json['reason'] as String
      ..url = json['url'] as String;

Map<String, dynamic> _$BiliBiliRecordToJson(BiliBiliRecord instance) =>
    <String, dynamic>{
      'title': instance.title,
      'cover': instance.cover,
      'reason': instance.reason,
      'url': instance.url,
    };
