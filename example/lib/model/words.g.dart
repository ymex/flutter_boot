// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'words.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Words _$WordsFromJson(Map<String, dynamic> json) => Words()
  ..code = anyToString(json['code'])
  ..error = json['error'] as String?
  ..cycx = json['cycx'] as String?
  ..cyjs = json['cyjs'] as String?
  ..cycc = json['cycc'] as String?
  ..cyzj = json['cyzj'] as String?
  ..cybx = json['cybx'] as String?
  ..cysy = json['cysy'] as String?;

Map<String, dynamic> _$WordsToJson(Words instance) => <String, dynamic>{
      'code': instance.code,
      'error': instance.error,
      'cycx': instance.cycx,
      'cyjs': instance.cyjs,
      'cycc': instance.cycc,
      'cyzj': instance.cyzj,
      'cybx': instance.cybx,
      'cysy': instance.cysy,
    };
