// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoryInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryInfo _$CategoryInfoFromJson(Map<String, dynamic> json) => CategoryInfo()
  ..id = json['id'] as num
  ..name = json['name'] as String
  ..books = (json['books'] as List<dynamic>)
      .map((e) => DictionaryInfo.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$CategoryInfoToJson(CategoryInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'books': instance.books,
    };
