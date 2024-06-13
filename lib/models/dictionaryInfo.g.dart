// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionaryInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DictionaryInfo _$DictionaryInfoFromJson(Map<String, dynamic> json) =>
    DictionaryInfo()
      ..hash = json['hash'] as String
      ..name = json['name'] as String
      ..progress = json['progress'] as num;

Map<String, dynamic> _$DictionaryInfoToJson(DictionaryInfo instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'name': instance.name,
      'progress': instance.progress,
    };
