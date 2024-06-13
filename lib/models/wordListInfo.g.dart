// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wordListInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordListInfo _$WordListInfoFromJson(Map<String, dynamic> json) => WordListInfo()
  ..hash = json['hash'] as String
  ..words = (json['words'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$WordListInfoToJson(WordListInfo instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'words': instance.words,
    };
