// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslationData _$TranslationDataFromJson(Map<String, dynamic> json) =>
    TranslationData()
      ..id = json['id'] as String
      ..tableName = json['tableName'] as String
      ..uri = json['uri'] as String
      ..languageCode = json['languageCode'] as String
      ..language = json['language'] as String
      ..name = json['name'] as String
      ..translator = json['translator'] as String
      ..type = $enumDecode(_$TranslationTypeEnumMap, json['type']);

Map<String, dynamic> _$TranslationDataToJson(TranslationData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableName': instance.tableName,
      'uri': instance.uri,
      'languageCode': instance.languageCode,
      'language': instance.language,
      'name': instance.name,
      'translator': instance.translator,
      'type': _$TranslationTypeEnumMap[instance.type]!,
    };

const _$TranslationTypeEnumMap = {
  TranslationType.builtIn: 'builtIn',
  TranslationType.download: 'download',
};
