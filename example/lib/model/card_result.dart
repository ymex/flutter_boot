import 'package:json_annotation/json_annotation.dart';

part 'card_result.g.dart';

@JsonSerializable()
class CardResult {
  @JsonKey(defaultValue: '')
  final String status;
  @JsonKey(defaultValue: 0)
  final int code;
  final Data? data;

  const CardResult({
    required this.status,
    required this.code,
    this.data,
  });

  factory CardResult.fromJson(Map<String, dynamic> json) =>
      _$CardResultFromJson(json);

  Map<String, dynamic> toJson() => _$CardResultToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(defaultValue: '')
  final String idcard;
  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String birthday;
  @JsonKey(defaultValue: '')
  final String sex;
  @JsonKey(defaultValue: '')
  final String constellation;
  @JsonKey(defaultValue: '')
  final String effective;

  const Data({
    required this.idcard,
    required this.address,
    required this.birthday,
    required this.sex,
    required this.constellation,
    required this.effective,
  });

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
