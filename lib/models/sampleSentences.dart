import 'package:json_annotation/json_annotation.dart';

part 'sampleSentences.g.dart';

@JsonSerializable()
class SampleSentences {
  SampleSentences();

  late String en;
  String? cn;
  
  factory SampleSentences.fromJson(Map<String,dynamic> json) => _$SampleSentencesFromJson(json);
  Map<String, dynamic> toJson() => _$SampleSentencesToJson(this);
}
