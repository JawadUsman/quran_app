// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_navigator_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QuranNavigatorStore on _QuranNavigatorStore, Store {
  late final _$chaptersAtom =
      Atom(name: '_QuranNavigatorStore.chapters', context: context);

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

  late final _$initialSelectedChapterAtom = Atom(
      name: '_QuranNavigatorStore.initialSelectedChapter', context: context);

  @override
  Chapters? get initialSelectedChapter {
    _$initialSelectedChapterAtom.reportRead();
    return super.initialSelectedChapter;
  }

  @override
  set initialSelectedChapter(Chapters? value) {
    _$initialSelectedChapterAtom
        .reportWrite(value, super.initialSelectedChapter, () {
      super.initialSelectedChapter = value;
    });
  }

  late final _$listAyaAtom =
      Atom(name: '_QuranNavigatorStore.listAya', context: context);

  @override
  ObservableList<int> get listAya {
    _$listAyaAtom.reportRead();
    return super.listAya;
  }

  @override
  set listAya(ObservableList<int> value) {
    _$listAyaAtom.reportWrite(value, super.listAya, () {
      super.listAya = value;
    });
  }

  late final _$selectedAyaAtom =
      Atom(name: '_QuranNavigatorStore.selectedAya', context: context);

  @override
  int get selectedAya {
    _$selectedAyaAtom.reportRead();
    return super.selectedAya;
  }

  @override
  set selectedAya(int value) {
    _$selectedAyaAtom.reportWrite(value, super.selectedAya, () {
      super.selectedAya = value;
    });
  }

  @override
  String toString() {
    return '''
chapters: ${chapters},
initialSelectedChapter: ${initialSelectedChapter},
listAya: ${listAya},
selectedAya: ${selectedAya}
    ''';
  }
}
