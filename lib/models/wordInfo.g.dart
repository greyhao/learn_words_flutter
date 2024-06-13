// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wordInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordInfo _$WordInfoFromJson(Map<String, dynamic> json) => WordInfo()
  ..word = json['word'] as String
  ..frequence = json['frequence'] as num
  ..sampleSentences = (json['sampleSentences'] as List<dynamic>?)
      ?.map((e) => SampleSentences.fromJson(e as Map<String, dynamic>))
      .toList()
  ..phonetic = json['phonetic'] as String?
  ..britishPhonetic = json['britishPhonetic'] as String?
  ..americanPhonetic = json['americanPhonetic'] as String?
  ..definition = json['definition'] as String?
  ..translation =
      (json['translation'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..tag = json['tag'] as String?;

Map<String, dynamic> _$WordInfoToJson(WordInfo instance) => <String, dynamic>{
      'word': instance.word,
      'frequence': instance.frequence,
      'sampleSentences': instance.sampleSentences,
      'phonetic': instance.phonetic,
      'britishPhonetic': instance.britishPhonetic,
      'americanPhonetic': instance.americanPhonetic,
      'definition': instance.definition,
      'translation': instance.translation,
      'tag': instance.tag,
    };
