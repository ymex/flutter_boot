import 'package:json_annotation/json_annotation.dart';

part 'base_model.g.dart';
@JsonSerializable(genericArgumentFactories: true)
class BaseModel<T> {
  late int code;
  String msg = '';
  @JsonKey(name: 'data')
  T? data;

  BaseModel();

  factory BaseModel.fromJson(Map<String, dynamic> json, T Function(dynamic json) fromJsonT) => _$BaseModelFromJson(json,fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$BaseModelToJson(this,toJsonT);
}