// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeItem _$ThemeItemFromJson(Map<String, dynamic> json) => ThemeItem(
      name: json['name'] as String? ?? '',
      themeType: $enumDecodeNullable(_$ThemeTypeEnumMap, json['themeType']),
    );

Map<String, dynamic> _$ThemeItemToJson(ThemeItem instance) => <String, dynamic>{
      'name': instance.name,
      'themeType': _$ThemeTypeEnumMap[instance.themeType]!,
    };

const _$ThemeTypeEnumMap = {
  ThemeType.Light: 'Light',
  ThemeType.Night: 'Night',
};
