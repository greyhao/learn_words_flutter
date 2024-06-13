import 'package:json_annotation/json_annotation.dart';

part 'wordListInfo.g.dart';

@JsonSerializable()
class WordListInfo {
  WordListInfo();

  late String hash;
  late List<String> words;
  
  factory WordListInfo.fromJson(Map<String,dynamic> json) => _$WordListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WordListInfoToJson(this);
}
