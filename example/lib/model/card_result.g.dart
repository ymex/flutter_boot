// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardResult _$CardResultFromJson(Map<String, dynamic> json) => CardResult(
      status: json['status'] as String? ?? '',
      code: (json['code'] as num?)?.toInt() ?? 0,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CardResultToJson(CardResult instance) =>
    <String, dynamic>{
      'status': instance.status,
      'code': instance.code,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      idcard: json['idcard'] as String? ?? '',
      address: json['address'] as String? ?? '',
      birthday: json['birthday'] as String? ?? '',
      sex: json['sex'] as String? ?? '',
      constellation: json['constellation'] as String? ?? '',
      effective: json['effective'] as String? ?? '',
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'idcard': instance.idcard,
      'address': instance.address,
      'birthday': instance.birthday,
      'sex': instance.sex,
      'constellation': instance.constellation,
      'effective': instance.effective,
    };
