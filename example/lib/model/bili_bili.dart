import 'package:example/model/bili_bili_record.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bili_bili.g.dart';
@JsonSerializable(genericArgumentFactories: true)
class BiliBili {
  late String name;
  String label = '';
  @JsonKey(name: 'list')
  late List<BiliBiliRecord> list;

  BiliBili();

  factory BiliBili.fromJson(Map<String, dynamic> json) => _$BiliBiliFromJson(json);

  Map<String, dynamic> toJson() => _$BiliBiliToJson(this);

  @override
  String toString() {
    return 'BiliBili{name: $name, label: $label, list: $list}';
  }
}