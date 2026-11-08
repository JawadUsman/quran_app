// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_settings_translations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QuranSettingsTranslationsStore
    on _QuranSettingsTranslationsStore, Store {
  late final _$translationsAtom = Atom(
      name: '_QuranSettingsTranslationsStore.translations', context: context);

  @override
  ObservableList<QuranSettingsTranslationItemStore> get translations {
    _$translationsAtom.reportRead();
    return super.translations;
  }

  @override
  set translations(ObservableList<QuranSettingsTranslationItemStore> value) {
    _$translationsAtom.reportWrite(value, super.translations, () {
      super.translations = value;
    });
  }

  @override
  String toString() {
    return '''
translations: ${translations}
    ''';
  }
}
