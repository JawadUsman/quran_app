// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_provider.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Sura> _$suraSerializer = _$SuraSerializer();
Serializer<Aya> _$ayaSerializer = _$AyaSerializer();
Serializer<AyaTranslation> _$ayaTranslationSerializer =
    _$AyaTranslationSerializer();

class _$SuraSerializer implements StructuredSerializer<Sura> {
  @override
  final Iterable<Type> types = const [Sura, _$Sura];
  @override
  final String wireName = 'Sura';

  @override
  Iterable<Object?> serialize(Serializers serializers, Sura object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'index',
      serializers.serialize(object.index,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'aya',
      serializers.serialize(object.aya,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Aya)])),
    ];

    return result;
  }

  @override
  Sura deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = SuraBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'index':
          result.index = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'aya':
          result.aya.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Aya)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$AyaSerializer implements StructuredSerializer<Aya> {
  @override
  final Iterable<Type> types = const [Aya, _$Aya];
  @override
  final String wireName = 'Aya';

  @override
  Iterable<Object?> serialize(Serializers serializers, Aya object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'index',
      serializers.serialize(object.indexString,
          specifiedType: const FullType(String)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.ruku;
    if (value != null) {
      result
        ..add('ruku')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  Aya deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = AyaBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'index':
          result.indexString = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'ruku':
          result.ruku = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
      }
    }

    return result.build();
  }
}

class _$AyaTranslationSerializer
    implements StructuredSerializer<AyaTranslation> {
  @override
  final Iterable<Type> types = const [AyaTranslation, _$AyaTranslation];
  @override
  final String wireName = 'AyaTranslation';

  @override
  Iterable<Object?> serialize(Serializers serializers, AyaTranslation object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'languageCode',
      serializers.serialize(object.languageCode,
          specifiedType: const FullType(String)),
      'translation',
      serializers.serialize(object.translation,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  AyaTranslation deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = AyaTranslationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'languageCode':
          result.languageCode = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'translation':
          result.translation = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Sura extends Sura {
  @override
  final String index;
  @override
  final String name;
  @override
  final BuiltList<Aya> aya;

  factory _$Sura([void Function(SuraBuilder)? updates]) =>
      (SuraBuilder()..update(updates))._build();

  _$Sura._({required this.index, required this.name, required this.aya})
      : super._();
  @override
  Sura rebuild(void Function(SuraBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SuraBuilder toBuilder() => SuraBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Sura &&
        index == other.index &&
        name == other.name &&
        aya == other.aya;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, index.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, aya.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Sura')
          ..add('index', index)
          ..add('name', name)
          ..add('aya', aya))
        .toString();
  }
}

class SuraBuilder implements Builder<Sura, SuraBuilder> {
  _$Sura? _$v;

  String? _index;
  String? get index => _$this._index;
  set index(String? index) => _$this._index = index;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<Aya>? _aya;
  ListBuilder<Aya> get aya => _$this._aya ??= ListBuilder<Aya>();
  set aya(ListBuilder<Aya>? aya) => _$this._aya = aya;

  SuraBuilder();

  SuraBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _index = $v.index;
      _name = $v.name;
      _aya = $v.aya.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Sura other) {
    _$v = other as _$Sura;
  }

  @override
  void update(void Function(SuraBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Sura build() => _build();

  _$Sura _build() {
    _$Sura _$result;
    try {
      _$result = _$v ??
          _$Sura._(
            index:
                BuiltValueNullFieldError.checkNotNull(index, r'Sura', 'index'),
            name: BuiltValueNullFieldError.checkNotNull(name, r'Sura', 'name'),
            aya: aya.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'aya';
        aya.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Sura', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Aya extends Aya {
  @override
  final String indexString;
  @override
  final String text;
  @override
  final int? ruku;
  @override
  final TranslationData? translationData;
  @override
  final BuiltList<Aya>? translations;

  factory _$Aya([void Function(AyaBuilder)? updates]) =>
      (AyaBuilder()..update(updates))._build();

  _$Aya._(
      {required this.indexString,
      required this.text,
      this.ruku,
      this.translationData,
      this.translations})
      : super._();
  @override
  Aya rebuild(void Function(AyaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AyaBuilder toBuilder() => AyaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Aya &&
        indexString == other.indexString &&
        text == other.text &&
        ruku == other.ruku &&
        translationData == other.translationData &&
        translations == other.translations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, indexString.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, ruku.hashCode);
    _$hash = $jc(_$hash, translationData.hashCode);
    _$hash = $jc(_$hash, translations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Aya')
          ..add('indexString', indexString)
          ..add('text', text)
          ..add('ruku', ruku)
          ..add('translationData', translationData)
          ..add('translations', translations))
        .toString();
  }
}

class AyaBuilder implements Builder<Aya, AyaBuilder> {
  _$Aya? _$v;

  String? _indexString;
  String? get indexString => _$this._indexString;
  set indexString(String? indexString) => _$this._indexString = indexString;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  int? _ruku;
  int? get ruku => _$this._ruku;
  set ruku(int? ruku) => _$this._ruku = ruku;

  TranslationData? _translationData;
  TranslationData? get translationData => _$this._translationData;
  set translationData(TranslationData? translationData) =>
      _$this._translationData = translationData;

  ListBuilder<Aya>? _translations;
  ListBuilder<Aya> get translations =>
      _$this._translations ??= ListBuilder<Aya>();
  set translations(ListBuilder<Aya>? translations) =>
      _$this._translations = translations;

  AyaBuilder();

  AyaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _indexString = $v.indexString;
      _text = $v.text;
      _ruku = $v.ruku;
      _translationData = $v.translationData;
      _translations = $v.translations?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Aya other) {
    _$v = other as _$Aya;
  }

  @override
  void update(void Function(AyaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Aya build() => _build();

  _$Aya _build() {
    _$Aya _$result;
    try {
      _$result = _$v ??
          _$Aya._(
            indexString: BuiltValueNullFieldError.checkNotNull(
                indexString, r'Aya', 'indexString'),
            text: BuiltValueNullFieldError.checkNotNull(text, r'Aya', 'text'),
            ruku: ruku,
            translationData: translationData,
            translations: _translations?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'translations';
        _translations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Aya', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$AyaTranslation extends AyaTranslation {
  @override
  final String languageCode;
  @override
  final String translation;

  factory _$AyaTranslation([void Function(AyaTranslationBuilder)? updates]) =>
      (AyaTranslationBuilder()..update(updates))._build();

  _$AyaTranslation._({required this.languageCode, required this.translation})
      : super._();
  @override
  AyaTranslation rebuild(void Function(AyaTranslationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AyaTranslationBuilder toBuilder() => AyaTranslationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AyaTranslation &&
        languageCode == other.languageCode &&
        translation == other.translation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, languageCode.hashCode);
    _$hash = $jc(_$hash, translation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AyaTranslation')
          ..add('languageCode', languageCode)
          ..add('translation', translation))
        .toString();
  }
}

class AyaTranslationBuilder
    implements Builder<AyaTranslation, AyaTranslationBuilder> {
  _$AyaTranslation? _$v;

  String? _languageCode;
  String? get languageCode => _$this._languageCode;
  set languageCode(String? languageCode) => _$this._languageCode = languageCode;

  String? _translation;
  String? get translation => _$this._translation;
  set translation(String? translation) => _$this._translation = translation;

  AyaTranslationBuilder();

  AyaTranslationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _languageCode = $v.languageCode;
      _translation = $v.translation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AyaTranslation other) {
    _$v = other as _$AyaTranslation;
  }

  @override
  void update(void Function(AyaTranslationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AyaTranslation build() => _build();

  _$AyaTranslation _build() {
    final _$result = _$v ??
        _$AyaTranslation._(
          languageCode: BuiltValueNullFieldError.checkNotNull(
              languageCode, r'AyaTranslation', 'languageCode'),
          translation: BuiltValueNullFieldError.checkNotNull(
              translation, r'AyaTranslation', 'translation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
