import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/helpers/sort_comparison_builder.dart';
import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../../main.dart';
import '../quran_settings/quran_settings_store.dart';
import '../../models/setting_ids.dart';
import 'quran_settings_translation_item_store.dart';

part 'quran_settings_translations_store.g.dart';

class QuranSettingsTranslationsStore = _QuranSettingsTranslationsStore
    with _$QuranSettingsTranslationsStore;

abstract class _QuranSettingsTranslationsStore extends BaseStore
    with Store
    implements QuranSettingsStoreProvider {
  late ILocalizationService localization;
  late QuranProvider quranProvider;

  _QuranSettingsTranslationsStore({
    required Map<Type, Object> parameter,
    QuranProvider? quranProvider,
  }) {
    this.localization = sl.get<ILocalizationService>()!;
    this.quranProvider = quranProvider ?? sl.get<QuranProvider>()!;

    _settingsItems = SettingsItem()
      ..name = localization.getByKey(
        'quran_settings_translations.translations',
      );

    void disposeTraslations() {
      for (var f in translations) {
        f.dispose();
      }
    }

    var comparisoBuilder =
        SortComparisonBuilder<QuranSettingsTranslationItemStore>();
    comparisoBuilder
      ..ascending((t) => t.translationData.type.index)
      ..thenByAscending((t) => t.translationData.language)
      ..thenByAscending((t) => t.translationData.name)
      ..thenByAscending((t) => t.translationData.translator);
    getListTranslations = Command(() async {
      try {
        dataState$.add(DataState(enumSelector: EnumSelector.loading));

        if (parameter[QuranSettingsTranslationsStore] != null) {
          ObservableList<TranslationData> fetchedTranslations =
              parameter[QuranSettingsTranslationsStore] as ObservableList<TranslationData>;
          var _translations =
              await Stream.fromIterable(fetchedTranslations).asyncExpand((v) {
            var item = QuranSettingsTranslationItemStore(v);
            return Stream.value(item);
          }).toList();
          _translations.sort((x, y) => comparisoBuilder.getCompareTo(x, y));
          disposeTraslations();
          translations.clear();
          translations.addAll(_translations);
        }
      } finally {
        dataState$.add(DataState(enumSelector: EnumSelector.success));
      }
    });

    translationChanged = Command.parameter((v) async {
      if (v == null) return;
      try {
        dataState$.add(DataState(enumSelector: EnumSelector.loading));

        v.item1.translationData.isSelected$.add(v.item2);

        var selectedTranslations = translations.where((t) {
          return t.translationData.isSelected$.value == true;
        }).map((f) {
          return f.translationData.id;
        }).toList();
        await rxPrefs.setStringList(
          SettingIds.translationId,
          selectedTranslations,
        );
      } finally {
        dataState$.add(DataState(enumSelector: EnumSelector.success));
      }
    });

    registerDispose(() {
      disposeTraslations();
    });
  }

  late SettingsItem _settingsItems;
  @override
  SettingsItem get settingsItem => _settingsItems;

  BehaviorSubject<DataState> dataState$ = BehaviorSubject.seeded(DataState(
    enumSelector: EnumSelector.none,
  ));

  late Command getListTranslations;

  @observable
  var translations = ObservableList<QuranSettingsTranslationItemStore>();

  late Command<Tuple2<QuranSettingsTranslationItemStore, bool>> translationChanged;
}
