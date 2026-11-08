// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QuranStore on _QuranStore, Store {
  late final _$sourceListAyaAtom =
      Atom(name: '_QuranStore.sourceListAya', context: context);

  @override
  ObservableList<Aya> get sourceListAya {
    _$sourceListAyaAtom.reportRead();
    return super.sourceListAya;
  }

  @override
  set sourceListAya(ObservableList<Aya> value) {
    _$sourceListAyaAtom.reportWrite(value, super.sourceListAya, () {
      super.sourceListAya = value;
    });
  }

  late final _$chaptersAtom =
      Atom(name: '_QuranStore.chapters', context: context);

  @override
  ObservableList<Chapters> get chapters {
    _$chaptersAtom.reportRead();
    return super.chapters;
  }

  @override
  set chapters(ObservableList<Chapters> value) {
    _$chaptersAtom.reportWrite(value, super.chapters, () {
      super.chapters = value;
    });
  }

  @override
  String toString() {
    return '''
sourceListAya: ${sourceListAya},
chapters: ${chapters}
    ''';
  }
}
