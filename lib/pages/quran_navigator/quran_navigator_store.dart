import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

part 'quran_navigator_store.g.dart';

class QuranNavigatorStore = _QuranNavigatorStore with _$QuranNavigatorStore;

abstract class _QuranNavigatorStore extends BaseStore with Store {
  late AppServices appServices;
  late QuranProvider quranProvider;
  late ILocalizationService localization;

  _QuranNavigatorStore({
    Map<String, Object>? parameter,
    AppServices? appServices,
    ILocalizationService? localizationService,
  }) {
    this.quranProvider = sl.get<QuranProvider>()!;
    this.appServices = appServices ?? sl.get<AppServices>()!;
    this.localization =
        localizationService ?? sl.get<ILocalizationService>()!;

    var _chapters = parameter?['chapters'] as List<Chapters>? ?? [];
    chapters.clear();
    chapters.addAll(_chapters);

    var selChapter = parameter?['selectedChapter'];
    if (chapters.any((t) => t == selChapter)) {
      initialSelectedChapter = chapters.firstWhere((t) => t == selChapter);
    } else if (chapters.isNotEmpty) {
      initialSelectedChapter = chapters.first;
    }
    if (initialSelectedChapter != null) {
      selectedChapter$.add(initialSelectedChapter!);
    }

    selectedAya = parameter?['selectedAya'] as int? ?? 1;

    {
      var d = selectedChapter$.listen((v) {
        var count = v.versesCount ?? 0;
        var _listAya = List.generate(count, (v) {
          return ++v;
        });
        listAya.clear();
        listAya.addAll(_listAya);

        var initialSelectedAya = 1;
        if (listAya.contains(selectedAya)) {
          initialSelectedAya = selectedAya;
        } else if (listAya.isNotEmpty) {
          initialSelectedAya = listAya.first;
        }
        initialSelectedaya$.add(initialSelectedAya);
        selectedAya = initialSelectedAya;
      });
      registerDispose(() {
        d.cancel();
      });
    }

    pickSura = Command(() {
      this.appServices.navigatorState?.pop({
        'chapter': selectedChapter$.value,
        'aya': 1,
      });
      return Future.value();
    });

    pickAya = Command(() {
      this.appServices.navigatorState?.pop({
        'chapter': selectedChapter$.value,
        'aya': selectedAya,
      });
      return Future.value();
    });

    registerDispose(() {
      selectedChapter$.close();
      initialSelectedaya$.close();
    });
  }

  @observable
  ObservableList<Chapters> chapters = ObservableList();

  @observable
  Chapters? initialSelectedChapter;

  BehaviorSubject<Chapters> selectedChapter$ = BehaviorSubject(
    sync: true,
  );

  @observable
  ObservableList<int> listAya = ObservableList();

  BehaviorSubject<int> initialSelectedaya$ = BehaviorSubject(
    sync: true,
  );

  @observable
  int selectedAya = 1;

  late Command pickSura;

  late Command pickAya;
}
