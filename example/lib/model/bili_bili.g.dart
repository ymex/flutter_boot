// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bili_bili.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BiliBili _$BiliBiliFromJson(Map<String, dynamic> json) => BiliBili()
  ..name = json['name'] as String
  ..label = json['label'] as String
  ..list = (json['list'] as List<dynamic>)
      .map((e) => BiliBiliRecord.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$BiliBiliToJson(BiliBili instance) => <String, dynamic>{
      'name': instance.name,
      'label': instance.label,
      'list': instance.list,
    };
