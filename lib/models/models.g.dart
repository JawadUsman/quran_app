// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(Aya.serializer)
      ..add(AyaTranslation.serializer)
      ..add(ChapterData.serializer)
      ..add(Chapters.serializer)
      ..add(JuzItem.serializer)
      ..add(RootJuzItem.serializer)
      ..add(Sura.serializer)
      ..add(TranslatedName.serializer)
      ..add(VerseMappingJuzItem.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Aya)]),
          () => ListBuilder<Aya>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Chapters)]),
          () => ListBuilder<Chapters>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(JuzItem)]),
          () => ListBuilder<JuzItem>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>()))
    .build();
Serializer<ChapterData> _$chapterDataSerializer = _$ChapterDataSerializer();
Serializer<Chapters> _$chaptersSerializer = _$ChaptersSerializer();
Serializer<TranslatedName> _$translatedNameSerializer =
    _$TranslatedNameSerializer();
Serializer<RootJuzItem> _$rootJuzItemSerializer = _$RootJuzItemSerializer();
Serializer<JuzItem> _$juzItemSerializer = _$JuzItemSerializer();
Serializer<VerseMappingJuzItem> _$verseMappingJuzItemSerializer =
    _$VerseMappingJuzItemSerializer();

class _$ChapterDataSerializer implements StructuredSerializer<ChapterData> {
  @override
  final Iterable<Type> types = const [ChapterData, _$ChapterData];
  @override
  final String wireName = 'ChapterData';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChapterData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'chapters',
      serializers.serialize(object.chapters,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Chapters)])),
    ];

    return result;
  }

  @override
  ChapterData deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ChapterDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'chapters':
          result.chapters.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Chapters)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$ChaptersSerializer implements StructuredSerializer<Chapters> {
  @override
  final Iterable<Type> types = const [Chapters, _$Chapters];
  @override
  final String wireName = 'Chapters';

  @override
  Iterable<Object?> serialize(Serializers serializers, Chapters object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.chapterNumber;
    if (value != null) {
      result
        ..add('chapter_number')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.bismillahPre;
    if (value != null) {
      result
        ..add('bismillah_pre')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.revelationOrder;
    if (value != null) {
      result
        ..add('revelation_order')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.revelationPlace;
    if (value != null) {
      result
        ..add('revelation_place')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.nameComplex;
    if (value != null) {
      result
        ..add('name_complex')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.nameArabic;
    if (value != null) {
      result
        ..add('name_arabic')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.nameSimple;
    if (value != null) {
      result
        ..add('name_simple')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.audioURL;
    if (value != null) {
      result
        ..add('audio_url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.versesCount;
    if (value != null) {
      result
        ..add('verses_count')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.pages;
    if (value != null) {
      result
        ..add('pages')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(int)])));
    }
    value = object.translatedName;
    if (value != null) {
      result
        ..add('translated_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(TranslatedName)));
    }
    return result;
  }

  @override
  Chapters deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ChaptersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'chapter_number':
          result.chapterNumber = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'bismillah_pre':
          result.bismillahPre = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'revelation_order':
          result.revelationOrder = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'revelation_place':
          result.revelationPlace = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'name_complex':
          result.nameComplex = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'name_arabic':
          result.nameArabic = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'name_simple':
          result.nameSimple = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'audio_url':
          result.audioURL = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'verses_count':
          result.versesCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'pages':
          result.pages.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))!
              as BuiltList<Object?>);
          break;
        case 'translated_name':
          result.translatedName.replace(serializers.deserialize(value,
                  specifiedType: const FullType(TranslatedName))!
              as TranslatedName);
          break;
      }
    }

    return result.build();
  }
}

class _$TranslatedNameSerializer
    implements StructuredSerializer<TranslatedName> {
  @override
  final Iterable<Type> types = const [TranslatedName, _$TranslatedName];
  @override
  final String wireName = 'TranslatedName';

  @override
  Iterable<Object?> serialize(Serializers serializers, TranslatedName object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.languageName;
    if (value != null) {
      result
        ..add('languageName')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  TranslatedName deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = TranslatedNameBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'languageName':
          result.languageName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$RootJuzItemSerializer implements StructuredSerializer<RootJuzItem> {
  @override
  final Iterable<Type> types = const [RootJuzItem, _$RootJuzItem];
  @override
  final String wireName = 'RootJuzItem';

  @override
  Iterable<Object?> serialize(Serializers serializers, RootJuzItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'juzs',
      serializers.serialize(object.juzs,
          specifiedType:
              const FullType(BuiltList, const [const FullType(JuzItem)])),
    ];

    return result;
  }

  @override
  RootJuzItem deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = RootJuzItemBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'juzs':
          result.juzs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(JuzItem)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$JuzItemSerializer implements StructuredSerializer<JuzItem> {
  @override
  final Iterable<Type> types = const [JuzItem, _$JuzItem];
  @override
  final String wireName = 'JuzItem';

  @override
  Iterable<Object?> serialize(Serializers serializers, JuzItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'juz_number',
      serializers.serialize(object.juzNumber,
          specifiedType: const FullType(int)),
      'verse_mapping',
      serializers.serialize(object.verseMapping,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(String)])),
    ];

    return result;
  }

  @override
  JuzItem deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = JuzItemBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'juz_number':
          result.juzNumber = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'verse_mapping':
          result.verseMapping.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(String)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$VerseMappingJuzItemSerializer
    implements StructuredSerializer<VerseMappingJuzItem> {
  @override
  final Iterable<Type> types = const [
    VerseMappingJuzItem,
    _$VerseMappingJuzItem
  ];
  @override
  final String wireName = 'VerseMappingJuzItem';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, VerseMappingJuzItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.surah;
    if (value != null) {
      result
        ..add('surah')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.startAya;
    if (value != null) {
      result
        ..add('startAya')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.endAya;
    if (value != null) {
      result
        ..add('endAya')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  VerseMappingJuzItem deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = VerseMappingJuzItemBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'surah':
          result.surah = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'startAya':
          result.startAya = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'endAya':
          result.endAya = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
      }
    }

    return result.build();
  }
}

class _$ChapterData extends ChapterData {
  @override
  final BuiltList<Chapters> chapters;

  factory _$ChapterData([void Function(ChapterDataBuilder)? updates]) =>
      (ChapterDataBuilder()..update(updates))._build();

  _$ChapterData._({required this.chapters}) : super._();
  @override
  ChapterData rebuild(void Function(ChapterDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChapterDataBuilder toBuilder() => ChapterDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChapterData && chapters == other.chapters;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, chapters.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChapterData')
          ..add('chapters', chapters))
        .toString();
  }
}

class ChapterDataBuilder implements Builder<ChapterData, ChapterDataBuilder> {
  _$ChapterData? _$v;

  ListBuilder<Chapters>? _chapters;
  ListBuilder<Chapters> get chapters =>
      _$this._chapters ??= ListBuilder<Chapters>();
  set chapters(ListBuilder<Chapters>? chapters) => _$this._chapters = chapters;

  ChapterDataBuilder();

  ChapterDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _chapters = $v.chapters.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChapterData other) {
    _$v = other as _$ChapterData;
  }

  @override
  void update(void Function(ChapterDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChapterData build() => _build();

  _$ChapterData _build() {
    _$ChapterData _$result;
    try {
      _$result = _$v ??
          _$ChapterData._(
            chapters: chapters.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'chapters';
        chapters.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChapterData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Chapters extends Chapters {
  @override
  final int? id;
  @override
  final int? chapterNumber;
  @override
  final bool? bismillahPre;
  @override
  final int? revelationOrder;
  @override
  final String? revelationPlace;
  @override
  final String? nameComplex;
  @override
  final String? nameArabic;
  @override
  final String? nameSimple;
  @override
  final String? audioURL;
  @override
  final int? versesCount;
  @override
  final BuiltList<int>? pages;
  @override
  final TranslatedName? translatedName;

  factory _$Chapters([void Function(ChaptersBuilder)? updates]) =>
      (ChaptersBuilder()..update(updates))._build();

  _$Chapters._(
      {this.id,
      this.chapterNumber,
      this.bismillahPre,
      this.revelationOrder,
      this.revelationPlace,
      this.nameComplex,
      this.nameArabic,
      this.nameSimple,
      this.audioURL,
      this.versesCount,
      this.pages,
      this.translatedName})
      : super._();
  @override
  Chapters rebuild(void Function(ChaptersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChaptersBuilder toBuilder() => ChaptersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Chapters &&
        id == other.id &&
        chapterNumber == other.chapterNumber &&
        bismillahPre == other.bismillahPre &&
        revelationOrder == other.revelationOrder &&
        revelationPlace == other.revelationPlace &&
        nameComplex == other.nameComplex &&
        nameArabic == other.nameArabic &&
        nameSimple == other.nameSimple &&
        audioURL == other.audioURL &&
        versesCount == other.versesCount &&
        pages == other.pages &&
        translatedName == other.translatedName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, chapterNumber.hashCode);
    _$hash = $jc(_$hash, bismillahPre.hashCode);
    _$hash = $jc(_$hash, revelationOrder.hashCode);
    _$hash = $jc(_$hash, revelationPlace.hashCode);
    _$hash = $jc(_$hash, nameComplex.hashCode);
    _$hash = $jc(_$hash, nameArabic.hashCode);
    _$hash = $jc(_$hash, nameSimple.hashCode);
    _$hash = $jc(_$hash, audioURL.hashCode);
    _$hash = $jc(_$hash, versesCount.hashCode);
    _$hash = $jc(_$hash, pages.hashCode);
    _$hash = $jc(_$hash, translatedName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Chapters')
          ..add('id', id)
          ..add('chapterNumber', chapterNumber)
          ..add('bismillahPre', bismillahPre)
          ..add('revelationOrder', revelationOrder)
          ..add('revelationPlace', revelationPlace)
          ..add('nameComplex', nameComplex)
          ..add('nameArabic', nameArabic)
          ..add('nameSimple', nameSimple)
          ..add('audioURL', audioURL)
          ..add('versesCount', versesCount)
          ..add('pages', pages)
          ..add('translatedName', translatedName))
        .toString();
  }
}

class ChaptersBuilder implements Builder<Chapters, ChaptersBuilder> {
  _$Chapters? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _chapterNumber;
  int? get chapterNumber => _$this._chapterNumber;
  set chapterNumber(int? chapterNumber) =>
      _$this._chapterNumber = chapterNumber;

  bool? _bismillahPre;
  bool? get bismillahPre => _$this._bismillahPre;
  set bismillahPre(bool? bismillahPre) => _$this._bismillahPre = bismillahPre;

  int? _revelationOrder;
  int? get revelationOrder => _$this._revelationOrder;
  set revelationOrder(int? revelationOrder) =>
      _$this._revelationOrder = revelationOrder;

  String? _revelationPlace;
  String? get revelationPlace => _$this._revelationPlace;
  set revelationPlace(String? revelationPlace) =>
      _$this._revelationPlace = revelationPlace;

  String? _nameComplex;
  String? get nameComplex => _$this._nameComplex;
  set nameComplex(String? nameComplex) => _$this._nameComplex = nameComplex;

  String? _nameArabic;
  String? get nameArabic => _$this._nameArabic;
  set nameArabic(String? nameArabic) => _$this._nameArabic = nameArabic;

  String? _nameSimple;
  String? get nameSimple => _$this._nameSimple;
  set nameSimple(String? nameSimple) => _$this._nameSimple = nameSimple;

  String? _audioURL;
  String? get audioURL => _$this._audioURL;
  set audioURL(String? audioURL) => _$this._audioURL = audioURL;

  int? _versesCount;
  int? get versesCount => _$this._versesCount;
  set versesCount(int? versesCount) => _$this._versesCount = versesCount;

  ListBuilder<int>? _pages;
  ListBuilder<int> get pages => _$this._pages ??= ListBuilder<int>();
  set pages(ListBuilder<int>? pages) => _$this._pages = pages;

  TranslatedNameBuilder? _translatedName;
  TranslatedNameBuilder get translatedName =>
      _$this._translatedName ??= TranslatedNameBuilder();
  set translatedName(TranslatedNameBuilder? translatedName) =>
      _$this._translatedName = translatedName;

  ChaptersBuilder();

  ChaptersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _chapterNumber = $v.chapterNumber;
      _bismillahPre = $v.bismillahPre;
      _revelationOrder = $v.revelationOrder;
      _revelationPlace = $v.revelationPlace;
      _nameComplex = $v.nameComplex;
      _nameArabic = $v.nameArabic;
      _nameSimple = $v.nameSimple;
      _audioURL = $v.audioURL;
      _versesCount = $v.versesCount;
      _pages = $v.pages?.toBuilder();
      _translatedName = $v.translatedName?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Chapters other) {
    _$v = other as _$Chapters;
  }

  @override
  void update(void Function(ChaptersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Chapters build() => _build();

  _$Chapters _build() {
    _$Chapters _$result;
    try {
      _$result = _$v ??
          _$Chapters._(
            id: id,
            chapterNumber: chapterNumber,
            bismillahPre: bismillahPre,
            revelationOrder: revelationOrder,
            revelationPlace: revelationPlace,
            nameComplex: nameComplex,
            nameArabic: nameArabic,
            nameSimple: nameSimple,
            audioURL: audioURL,
            versesCount: versesCount,
            pages: _pages?.build(),
            translatedName: _translatedName?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pages';
        _pages?.build();
        _$failedField = 'translatedName';
        _translatedName?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Chapters', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$TranslatedName extends TranslatedName {
  @override
  final String? languageName;
  @override
  final String? name;

  factory _$TranslatedName([void Function(TranslatedNameBuilder)? updates]) =>
      (TranslatedNameBuilder()..update(updates))._build();

  _$TranslatedName._({this.languageName, this.name}) : super._();
  @override
  TranslatedName rebuild(void Function(TranslatedNameBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TranslatedNameBuilder toBuilder() => TranslatedNameBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TranslatedName &&
        languageName == other.languageName &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, languageName.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TranslatedName')
          ..add('languageName', languageName)
          ..add('name', name))
        .toString();
  }
}

class TranslatedNameBuilder
    implements Builder<TranslatedName, TranslatedNameBuilder> {
  _$TranslatedName? _$v;

  String? _languageName;
  String? get languageName => _$this._languageName;
  set languageName(String? languageName) => _$this._languageName = languageName;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  TranslatedNameBuilder();

  TranslatedNameBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _languageName = $v.languageName;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TranslatedName other) {
    _$v = other as _$TranslatedName;
  }

  @override
  void update(void Function(TranslatedNameBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TranslatedName build() => _build();

  _$TranslatedName _build() {
    final _$result = _$v ??
        _$TranslatedName._(
          languageName: languageName,
          name: name,
        );
    replace(_$result);
    return _$result;
  }
}

class _$RootJuzItem extends RootJuzItem {
  @override
  final BuiltList<JuzItem> juzs;

  factory _$RootJuzItem([void Function(RootJuzItemBuilder)? updates]) =>
      (RootJuzItemBuilder()..update(updates))._build();

  _$RootJuzItem._({required this.juzs}) : super._();
  @override
  RootJuzItem rebuild(void Function(RootJuzItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RootJuzItemBuilder toBuilder() => RootJuzItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RootJuzItem && juzs == other.juzs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, juzs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RootJuzItem')..add('juzs', juzs))
        .toString();
  }
}

class RootJuzItemBuilder implements Builder<RootJuzItem, RootJuzItemBuilder> {
  _$RootJuzItem? _$v;

  ListBuilder<JuzItem>? _juzs;
  ListBuilder<JuzItem> get juzs => _$this._juzs ??= ListBuilder<JuzItem>();
  set juzs(ListBuilder<JuzItem>? juzs) => _$this._juzs = juzs;

  RootJuzItemBuilder();

  RootJuzItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _juzs = $v.juzs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RootJuzItem other) {
    _$v = other as _$RootJuzItem;
  }

  @override
  void update(void Function(RootJuzItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RootJuzItem build() => _build();

  _$RootJuzItem _build() {
    _$RootJuzItem _$result;
    try {
      _$result = _$v ??
          _$RootJuzItem._(
            juzs: juzs.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'juzs';
        juzs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RootJuzItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$JuzItem extends JuzItem {
  @override
  final int id;
  @override
  final int juzNumber;
  @override
  final BuiltMap<String, String> verseMapping;
  @override
  final Chapters? chapters;
  @override
  final BuiltList<Aya>? listAya;

  factory _$JuzItem([void Function(JuzItemBuilder)? updates]) =>
      (JuzItemBuilder()..update(updates))._build();

  _$JuzItem._(
      {required this.id,
      required this.juzNumber,
      required this.verseMapping,
      this.chapters,
      this.listAya})
      : super._();
  @override
  JuzItem rebuild(void Function(JuzItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JuzItemBuilder toBuilder() => JuzItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JuzItem &&
        id == other.id &&
        juzNumber == other.juzNumber &&
        verseMapping == other.verseMapping &&
        chapters == other.chapters &&
        listAya == other.listAya;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, juzNumber.hashCode);
    _$hash = $jc(_$hash, verseMapping.hashCode);
    _$hash = $jc(_$hash, chapters.hashCode);
    _$hash = $jc(_$hash, listAya.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JuzItem')
          ..add('id', id)
          ..add('juzNumber', juzNumber)
          ..add('verseMapping', verseMapping)
          ..add('chapters', chapters)
          ..add('listAya', listAya))
        .toString();
  }
}

class JuzItemBuilder implements Builder<JuzItem, JuzItemBuilder> {
  _$JuzItem? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _juzNumber;
  int? get juzNumber => _$this._juzNumber;
  set juzNumber(int? juzNumber) => _$this._juzNumber = juzNumber;

  MapBuilder<String, String>? _verseMapping;
  MapBuilder<String, String> get verseMapping =>
      _$this._verseMapping ??= MapBuilder<String, String>();
  set verseMapping(MapBuilder<String, String>? verseMapping) =>
      _$this._verseMapping = verseMapping;

  ChaptersBuilder? _chapters;
  ChaptersBuilder get chapters => _$this._chapters ??= ChaptersBuilder();
  set chapters(ChaptersBuilder? chapters) => _$this._chapters = chapters;

  ListBuilder<Aya>? _listAya;
  ListBuilder<Aya> get listAya => _$this._listAya ??= ListBuilder<Aya>();
  set listAya(ListBuilder<Aya>? listAya) => _$this._listAya = listAya;

  JuzItemBuilder();

  JuzItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _juzNumber = $v.juzNumber;
      _verseMapping = $v.verseMapping.toBuilder();
      _chapters = $v.chapters?.toBuilder();
      _listAya = $v.listAya?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JuzItem other) {
    _$v = other as _$JuzItem;
  }

  @override
  void update(void Function(JuzItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JuzItem build() => _build();

  _$JuzItem _build() {
    _$JuzItem _$result;
    try {
      _$result = _$v ??
          _$JuzItem._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'JuzItem', 'id'),
            juzNumber: BuiltValueNullFieldError.checkNotNull(
                juzNumber, r'JuzItem', 'juzNumber'),
            verseMapping: verseMapping.build(),
            chapters: _chapters?.build(),
            listAya: _listAya?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'verseMapping';
        verseMapping.build();
        _$failedField = 'chapters';
        _chapters?.build();
        _$failedField = 'listAya';
        _listAya?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'JuzItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$VerseMappingJuzItem extends VerseMappingJuzItem {
  @override
  final int? surah;
  @override
  final int? startAya;
  @override
  final int? endAya;

  factory _$VerseMappingJuzItem(
          [void Function(VerseMappingJuzItemBuilder)? updates]) =>
      (VerseMappingJuzItemBuilder()..update(updates))._build();

  _$VerseMappingJuzItem._({this.surah, this.startAya, this.endAya}) : super._();
  @override
  VerseMappingJuzItem rebuild(
          void Function(VerseMappingJuzItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VerseMappingJuzItemBuilder toBuilder() =>
      VerseMappingJuzItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VerseMappingJuzItem &&
        surah == other.surah &&
        startAya == other.startAya &&
        endAya == other.endAya;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, surah.hashCode);
    _$hash = $jc(_$hash, startAya.hashCode);
    _$hash = $jc(_$hash, endAya.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VerseMappingJuzItem')
          ..add('surah', surah)
          ..add('startAya', startAya)
          ..add('endAya', endAya))
        .toString();
  }
}

class VerseMappingJuzItemBuilder
    implements Builder<VerseMappingJuzItem, VerseMappingJuzItemBuilder> {
  _$VerseMappingJuzItem? _$v;

  int? _surah;
  int? get surah => _$this._surah;
  set surah(int? surah) => _$this._surah = surah;

  int? _startAya;
  int? get startAya => _$this._startAya;
  set startAya(int? startAya) => _$this._startAya = startAya;

  int? _endAya;
  int? get endAya => _$this._endAya;
  set endAya(int? endAya) => _$this._endAya = endAya;

  VerseMappingJuzItemBuilder();

  VerseMappingJuzItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _surah = $v.surah;
      _startAya = $v.startAya;
      _endAya = $v.endAya;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VerseMappingJuzItem other) {
    _$v = other as _$VerseMappingJuzItem;
  }

  @override
  void update(void Function(VerseMappingJuzItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VerseMappingJuzItem build() => _build();

  _$VerseMappingJuzItem _build() {
    final _$result = _$v ??
        _$VerseMappingJuzItem._(
          surah: surah,
          startAya: startAya,
          endAya: endAya,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
