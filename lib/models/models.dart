library surah;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:quran_app/services/quran_provider.dart';

part 'models.g.dart';

@SerializersFor([
  ChapterData,
  Chapters,
  TranslatedName,
  Sura,
  Aya,
  AyaTranslation,
  RootJuzItem,
  JuzItem,
  VerseMappingJuzItem,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
          const FullType(BuiltMap, [
            FullType(String),
            FullType(String),
          ]),
          () => MapBuilder<String, String>())
      ..addPlugin(StandardJsonPlugin()))
    .build();

abstract class ChapterData implements Built<ChapterData, ChapterDataBuilder> {
  ChapterData._();

  factory ChapterData([void Function(ChapterDataBuilder b)? updates]) = _$ChapterData;

  @BuiltValueField(wireName: 'chapters')
  BuiltList<Chapters> get chapters;
  String toJson() {
    return json.encode(serializers.serializeWith(ChapterData.serializer, this));
  }

  static ChapterData? fromJson(String jsonString) {
    return serializers.deserializeWith(
        ChapterData.serializer, json.decode(jsonString));
  }

  static Serializer<ChapterData> get serializer => _$chapterDataSerializer;
}

abstract class Chapters implements Built<Chapters, ChaptersBuilder> {
  Chapters._();

  factory Chapters([void Function(ChaptersBuilder b)? updates]) = _$Chapters;

  @BuiltValueField(wireName: 'id')
  int? get id;

  @BuiltValueField(wireName: 'chapter_number')
  int? get chapterNumber;

  @BuiltValueField(wireName: 'bismillah_pre')
  bool? get bismillahPre;

  @BuiltValueField(wireName: 'revelation_order')
  int? get revelationOrder;

  @BuiltValueField(wireName: 'revelation_place')
  String? get revelationPlace;

  @BuiltValueField(wireName: 'name_complex')
  String? get nameComplex;

  @BuiltValueField(wireName: 'name_arabic')
  String? get nameArabic;

  @BuiltValueField(wireName: 'name_simple')
  String? get nameSimple;

  @BuiltValueField(wireName: 'audio_url')
  String? get audioURL;

  @BuiltValueField(wireName: 'verses_count')
  int? get versesCount;

  @BuiltValueField(wireName: 'pages')
  BuiltList<int>? get pages;

  @BuiltValueField(wireName: 'translated_name')
  TranslatedName? get translatedName;

  String toJson() {
    return json.encode(serializers.serializeWith(Chapters.serializer, this));
  }

  static Chapters? fromJson(String jsonString) {
    return serializers.deserializeWith(
        Chapters.serializer, json.decode(jsonString));
  }

  static Serializer<Chapters> get serializer => _$chaptersSerializer;
}

abstract class TranslatedName
    implements Built<TranslatedName, TranslatedNameBuilder> {
  static Serializer<TranslatedName> get serializer =>
      _$translatedNameSerializer;

  String? get languageName;
  String? get name;

  TranslatedName._();
  factory TranslatedName([void Function(TranslatedNameBuilder)? updates]) =
      _$TranslatedName;
}

abstract class RootJuzItem implements Built<RootJuzItem, RootJuzItemBuilder> {
  RootJuzItem._();

  factory RootJuzItem([void Function(RootJuzItemBuilder b)? updates]) = _$RootJuzItem;

  @BuiltValueField(wireName: 'juzs')
  BuiltList<JuzItem> get juzs;
  String toJson() {
    return json.encode(serializers.serializeWith(RootJuzItem.serializer, this));
  }

  static RootJuzItem? fromJson(String jsonString) {
    return serializers.deserializeWith(
        RootJuzItem.serializer, json.decode(jsonString));
  }

  static Serializer<RootJuzItem> get serializer => _$rootJuzItemSerializer;
}

abstract class JuzItem implements Built<JuzItem, JuzItemBuilder> {
  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'juz_number')
  int get juzNumber;
  @BuiltValueField(wireName: 'verse_mapping')
  BuiltMap<String, String> get verseMapping;

  @BuiltValueField(
    serialize: false,
  )
  Chapters? get chapters;

  @BuiltValueField(
    serialize: false,
  )
  BuiltList<Aya>? get listAya;

  static BuiltList<VerseMappingJuzItem> getVerseMappingJuzItem(
      BuiltMap<String, String> verseMapping) {
    final List<VerseMappingJuzItem> list = [];
    verseMapping.forEach((t1, t2) {
      list.add(VerseMappingJuzItem((v) {
        v.surah = int.parse(t1);
        var splitted = t2.split('-').map((f) => int.parse(f.trim()));
        v.startAya = splitted.elementAt(0);
        v.endAya = splitted.elementAt(1);
      }));
    });
    return BuiltList<VerseMappingJuzItem>.from(list);
  }

  JuzItem._();
  factory JuzItem([void Function(JuzItemBuilder)? updates]) = _$JuzItem;

  Object? toMap() {
    return serializers.serializeWith(JuzItem.serializer, this);
  }

  static JuzItem? fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(JuzItem.serializer, map);
  }

  static Serializer<JuzItem> get serializer => _$juzItemSerializer;
}

abstract class VerseMappingJuzItem
    implements Built<VerseMappingJuzItem, VerseMappingJuzItemBuilder> {
  int? get surah;

  int? get startAya;

  int? get endAya;

  VerseMappingJuzItem._();
  factory VerseMappingJuzItem(
          [void Function(VerseMappingJuzItemBuilder)? updates]) =
      _$VerseMappingJuzItem;

  Object? toMap() {
    return serializers.serializeWith(VerseMappingJuzItem.serializer, this);
  }

  static VerseMappingJuzItem? fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(VerseMappingJuzItem.serializer, map);
  }

  static Serializer<VerseMappingJuzItem> get serializer =>
      _$verseMappingJuzItemSerializer;
}
