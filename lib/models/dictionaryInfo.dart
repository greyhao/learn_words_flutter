import 'package:json_annotation/json_annotation.dart';

part 'dictionaryInfo.g.dart';

@JsonSerializable()
class DictionaryInfo {
  DictionaryInfo();

  late String hash;
  late String name;
  late num progress;
  
  factory DictionaryInfo.fromJson(Map<String,dynamic> json) => _$DictionaryInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DictionaryInfoToJson(this);
}
