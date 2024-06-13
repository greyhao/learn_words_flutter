import 'package:json_annotation/json_annotation.dart';
import "dictionaryInfo.dart";
part 'categoryInfo.g.dart';

@JsonSerializable()
class CategoryInfo {
  CategoryInfo();

  late num id;
  late String name;
  late List<DictionaryInfo> books;
  
  factory CategoryInfo.fromJson(Map<String,dynamic> json) => _$CategoryInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryInfoToJson(this);
}
