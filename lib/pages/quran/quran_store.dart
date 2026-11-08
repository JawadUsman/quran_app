import 'package:mobx/mobx.dart';
import 'package:drift/drift.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/interaction.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/models/setting_ids.dart';
import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/pages/quran_settings_fontsizes/quran_settings_fontsizes_store.dart';
import 'package:quran_app/services/appdb.dart';
import 'package:quran_app/services/bookmarks_provider.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import '../quran_settings_translations/quran_settings_translations_store.dart';
import '../../extensions/settings_extension.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../../main.dart';

part 'quran_store.g.dart';

class QuranStore = _QuranStore with _$QuranStore;

abstract class _QuranStore extends BaseStore with Store {
  late QuranProvider _quranProvider;
  late ILocalizationService localization;
  late AppServices appServices;
  late BookmarksProvider bookmarksProvider;

  _QuranStore({
    Map<String, Object>? parameter,
    QuranProvider? quranProvider,
    ILocalizationService? localizationService,
    AppServices? appServices,
    BookmarksProvider? bookmarksProvider,
  }) {
    Chapters? selectedChapter = parameter?['chapter'] as Chapters?;
    if (selectedChapter != null) {
      selectedChapter$.add(selectedChapter);
    }

    this.localization = localizationService ?? sl.get<ILocalizationService>()!;
    _quranProvider = quranProvider ?? sl.get<QuranProvider>()!;
    this.appServices = appServices ?? sl.get<AppServices>()!;
    this.bookmarksProvider =
        bookmarksProvider ?? sl.get<BookmarksProvider>()!;

    initialize = Command(() async {
      try {
        state$.add(
          DataState(
            enumSelector: EnumSelector.loading,
          ),
        );

        listQuranTextData = await _quranProvider.getListQuranTextData();
        if (!selectedQuranTextData$.hasValue && listQuranTextData.isNotEmpty) {
          selectedQuranTextData$.add(listQuranTextData.first);
        }

        var _listTranslationData = await _quranProvider.getListTranslations();
        listTranslationData.clear();
        listTranslationData.addAll(_listTranslationData);

        await _quranProvider.initialize();

        var _chapters = await _quranProvider.getChapters(localization.locale ?? localization.neutralLocale);
        chapters.clear();
        chapters.addAll(_chapters);
        if (selectedChapter != null &&
            selectedChapter$.valueOrNull?.chapterNumber ==
                selectedChapter.chapterNumber) {
          var newSelectedChapter = _chapters.firstWhere(
            (t) => t.chapterNumber == selectedChapter.chapterNumber,
          );
          selectedChapter$.add(newSelectedChapter);
        }
      } finally {
        state$.add(
          DataState(
            enumSelector: EnumSelector.success,
          ),
        );
      }
    });

    getAya = RxCommand.createAsyncNoParam(() async {
      try {
        state$.add(
          DataState(
            enumSelector: EnumSelector.loading,
          ),
        );

        const defaultSelectedTranslationsIds = [
          '3622b2a1a74740c7bff5cf44c69d271v',
        ];
        var selectedTranslationIds =
            await rxPrefs.getStringList(SettingIds.translationId) ??
                defaultSelectedTranslationsIds;

        selectedListTranslationData = listTranslationData
            .map((t) {
              var isSelected = selectedTranslationIds.contains(t.id);
              if (!t.isSelected$.hasValue) {
                t.isSelected$.add(isSelected);
              }
              return t;
            })
            .where(
              (t) => t.isSelected$.value == true,
            )
            .toList();

        this.appServices.logger.i('Fetching aya');
        var listAyaByChapter = await _quranProvider.getAyaByChapter(
          selectedChapter$.value.chapterNumber!,
          selectedQuranTextData$.value,
          selectedListTranslationData,
        );
        this.appServices.logger.i('Done fetching aya');

        return listAyaByChapter;
      } finally {
        state$.add(
          DataState(
            enumSelector: EnumSelector.success,
          ),
        );
      }
    });

    {
      final ds = CompositeSubscription();

      ds.add(Stream.fromFuture(
        initialize.executeIf(),
      ).listen(null));

      var getAyaRefresh$ = PublishSubject<void>(
        sync: true,
      );

      ds.add(selectedChapter$.skip(1).map((t) => null).mergeWith(
        [
          getAyaRefresh$.map((t) => null),
        ],
      ).asyncExpand((_) {
        return DeferStream(() {
          getAya.execute();
          return getAya.next.asStream();
        });
      }).doOnData((v) {
        sourceListAya.clear();
        sourceListAya.addAll(v);
        if (!initialSelectedAya$.hasValue) {
          int? aya = parameter?['aya'] as int?;

          this.appServices.logger.d("jawad1 - Aya: $aya");
          Aya? f;
          if (sourceListAya.isNotEmpty) {
            f = sourceListAya.firstWhere(
              (t) => aya != null ? t.index == aya : true,
            );
          }

          this.appServices.logger.d("jawad1 - f value: $f");
          if (f != null) {
            initialSelectedAya$.add(f);
          }
        }
      }).handleError((e) {
        this.appServices.logger.e(e);
      }).listen(null));

      listTranslationData.observe(
        (change) {
          final rangeChanges = change.rangeChanges;
          if (rangeChanges != null) {
            for (var item in rangeChanges) {
              final addedValues = item.newValues;
              if (addedValues != null) {
                for (var v in addedValues) {
                  var d = v.isSelected$
                      .distinct(
                        (t1, t2) => t1 == t2,
                      )
                      .doOnData((v) {
                    getAyaRefresh$.add(null);
                  }).listen(null);
                  ds.add(d);
                }
              }
            }
          }
        },
      );

      registerDispose(() {
        ds.dispose();
      });
    }

    pickQuranNavigator = Command(() async {
      if (chapters.isEmpty || listAya.isEmpty) {
        return;
      }

      final Map<String, Object> p = {
        'chapters': chapters,
        'selectedChapter': selectedChapter$.value,
        'selectedAya': initialSelectedAya$.hasValue
            ? initialSelectedAya$.value.index
            : (sourceListAya.isNotEmpty ? sourceListAya.first.index : 1)
      };
      var result = await pickQuranNavigatorInteraction.handle(p);
      if (result != null) {
        if (result.containsKey('chapter')) {
          Chapters c = result['chapter'] as Chapters;
          var selectedChapter = c.toBuilder().build();
          selectedChapter$.add(selectedChapter);
        }
        if (result.containsKey('aya')) {
          await getAya.next;
          if (sourceListAya.any((t) => t.index == result['aya'])) {
            var selectedAya = sourceListAya.firstWhere((t) => t.index == result['aya']);
            initialSelectedAya$.add(selectedAya);
          }
        }
      }
    });

    showSettings = Command(() {
      settingsParameter.clear();

      settingsParameter.putIfAbsent(QuranSettingsTranslationsStore, () {
        return listTranslationData;
      });

      settingsParameter.putIfAbsent(QuranSettingsFontsizesStore, () {
        final Map<String, Object> m = {
          'arabicFontSize': arabicFontSize$,
          'translationFontSize': translationFontSize$,
        };
        return m;
      });
      return showSettingsInteraction.handle(null);
    });

    rxPrefs.getArabicFontSize().asStream().doOnData((v) {
      arabicFontSize$.add(v);
    }).listen(null);

    rxPrefs.getTranslationFontSize().asStream().doOnData((v) {
      translationFontSize$.add(v);
    }).listen(null);

    addBookmark = RxCommand.createAsyncNoResult((AyaStore item) async {
      var utc = DateTime.now();
      var v = QuranBookmarksCompanion(
        id: Value(item.aya.value.index),
        aya: Value(item.aya.value.index),
        insertTime: Value(utc.microsecondsSinceEpoch),
        sura: Value(item.chapter.chapterNumber!),
        suraName: Value(item.chapter.nameSimple ?? ''),
      );
      var id = await this.bookmarksProvider.addItem(v);
      this.appServices.logger.i('Addded item id: $id');

      item.getBookmark.execute();
    });

    removeBookmark = RxCommand.createAsyncNoResult(
      (Tuple3<QuranBookmarkButtonMode, AyaStore, QuranBookmark?> item) async {
        if (item.item3 != null) {
          var id = await this.bookmarksProvider.removeItem(item.item3!);
          this.appServices.logger.i('Removed item id: $id');
        }

        item.item2.isBookmarked.add(false);
      },
    );

    {
      var d = bookmarkActionType.asyncExpand((t) {
        if (t.item1 == QuranBookmarkButtonMode.add) {
          return DeferStream(() {
            addBookmark.execute(t.item2);
            return addBookmark.next.asStream();
          });
        } else {
          return DeferStream(() {
            removeBookmark.execute(t);
            return removeBookmark.next.asStream();
          });
        }
      }).doOnData((_) {
        this.appServices.logger.i('Bookmark action done');
      }).listen(null);
      registerDispose(() {
        d.cancel();
      });
    }

    registerDispose(() {
      selectedChapter$.close();
      selectedQuranTextData$.close();
    });
  }

  late Command initialize;

  late RxCommand<void, List<Aya>> getAya;

  late RxCommand<AyaStore, void> addBookmark;

  late RxCommand<Tuple3<QuranBookmarkButtonMode, AyaStore, QuranBookmark?>, void>
      removeBookmark;

  final bookmarkActionType = PublishSubject<
      Tuple3<QuranBookmarkButtonMode, AyaStore, QuranBookmark?>>();

  @observable
  ObservableList<Aya> sourceListAya = ObservableList();

  Computed<ObservableList<AyaStore>>? _listAyaComputed;

  ObservableList<AyaStore> get listAya =>
      (_listAyaComputed ??= Computed<ObservableList<AyaStore>>(
              () => ObservableList.of(sourceListAya.map((f) {
                    return AyaStore(
                      selectedChapter$.value,
                      f,
                      selectedListTranslationData,
                    );
                  }))))
          .value;

  BehaviorSubject<Aya> initialSelectedAya$ = BehaviorSubject(
    sync: true,
  );

  var state$ = BehaviorSubject<DataState>.seeded(
    DataState(
      enumSelector: EnumSelector.none,
    ),
  );

  List<QuranTextData> listQuranTextData = [];

  var selectedQuranTextData$ = BehaviorSubject<QuranTextData>(
    sync: true,
  );

  List<TranslationData> selectedListTranslationData = [];

  var listTranslationData = ObservableList<TranslationData>();

  @observable
  ObservableList<Chapters> chapters = ObservableList();

  var selectedChapter$ = BehaviorSubject<Chapters>(
    sync: true,
  );

  final Interaction<Map<String, Object>, Map<String, Object>>
      pickQuranNavigatorInteraction = Interaction();
  late Command pickQuranNavigator;

  final settingsParameter = <Type, Object>{};
  final showSettingsInteraction = Interaction<dynamic, dynamic>();
  late Command showSettings;

  final arabicFontSize$ = BehaviorSubject<double>.seeded(
    28,
    sync: true,
  );

  final translationFontSize$ = BehaviorSubject<double>.seeded(
    16,
    sync: true,
  );
}

enum QuranBookmarkButtonMode {
  add,
  remove,
}

class AyaStore {
  late AppServices appServices;
  late QuranProvider quranProvider;
  late BookmarksProvider bookmarksProvider;

  AyaStore(
    Chapters chapter,
    Aya aya,
    List<TranslationData> translationsData, {
    AppServices? appServices,
    QuranProvider? quranProvider,
    BookmarksProvider? bookmarksProvider,
  }) {
    this.chapter = chapter;
    this.aya.add(aya);

    this.appServices = appServices ?? sl.get<AppServices>()!;
    this.quranProvider = quranProvider ?? sl.get<QuranProvider>()!;
    this.bookmarksProvider =
        bookmarksProvider ?? sl.get<BookmarksProvider>()!;

    this.appServices.logger.i('Item aya ${aya.index}');

    getTranslations = RxCommand.createAsyncNoParamNoResult(() async {
      translationState.add(DataState(enumSelector: EnumSelector.loading));

      var _translation = await Stream.fromIterable(
        translationsData,
      )
          .asyncExpand((t) {
            return DeferStream(() {
              return this.quranProvider
                  .getTranslation(chapter.chapterNumber!, aya.index, t)
                  .asStream()
                  .map((aya) {
                if (aya == null) {
                  return null;
                }

                return Tuple2(aya, t);
              });
            });
          })
          .handleError((e) {
            this.appServices.logger.e(e ?? '');
          })
          .where((t) => t != null)
          .cast<Tuple2<Aya, TranslationData>>()
          .toList();
      if (!translations.hasValue) {
        translations.add(_translation);
      }

      translationState.add(DataState(enumSelector: EnumSelector.success));
    });

    getBookmark = RxCommand.createAsyncNoParamNoResult(() async {
      var item =
          await this.bookmarksProvider.getItem(aya.index, chapter.chapterNumber!);
      quranBookmark = item;
      isBookmarked.add(quranBookmark != null);
      this.appServices.logger.i('get quran bookmark: $quranBookmark');
    });
  }

  late RxCommand<void, void> getTranslations;

  late RxCommand<void, void> getBookmark;

  late Chapters chapter;

  final aya = BehaviorSubject<Aya>();

  final translations = BehaviorSubject<List<Tuple2<Aya, TranslationData>>>(
    sync: true,
  );

  final translationState = BehaviorSubject<DataState>(
    sync: true,
  );

  QuranBookmark? quranBookmark;

  final isBookmarked = BehaviorSubject<bool>.seeded(
    false,
  );
}
