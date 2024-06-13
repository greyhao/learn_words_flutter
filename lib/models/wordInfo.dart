import 'package:json_annotation/json_annotation.dart';
import "sampleSentences.dart";
part 'wordInfo.g.dart';

@JsonSerializable()
class WordInfo {
  WordInfo();

  late String word;
  late num frequence;
  List<SampleSentences>? sampleSentences;
  String? phonetic;
  String? britishPhonetic;
  String? americanPhonetic;
  String? definition;
  List<String>? translation;
  String? tag;
  
  factory WordInfo.fromJson(Map<String,dynamic> json) => _$WordInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WordInfoToJson(this);
}
