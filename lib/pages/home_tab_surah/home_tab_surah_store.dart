import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/services/quran_provider.dart';

import '../../main.dart';

part 'home_tab_surah_store.g.dart';

class HomeTabSurahStore = _HomeTabSurahStore with _$HomeTabSurahStore;

abstract class _HomeTabSurahStore extends BaseStore with Store {
  late AppServices _appServices;
  late ILocalizationService _localization;
  late QuranProvider _quranProvider;

  _HomeTabSurahStore({
    AppServices? appServices,
    QuranProvider? quranProvider,
    ILocalizationService? localizationService,
  }) {
    _appServices = appServices ?? sl.get<AppServices>()!;
    _quranProvider = quranProvider ?? sl.get<QuranProvider>()!;
    _localization = localizationService ?? sl.get<ILocalizationService>()!;

    fetchSurah = Command(() async {
      try {
        state = DataState(
          enumSelector: EnumSelector.loading,
        );

        var l = await _quranProvider.getChapters(_localization.neutralLocale);
        chapters.clear();
        chapters.addAll(l);

        state = DataState(
          enumSelector: EnumSelector.success,
        );
      } catch (e) {
        _appServices.logger.e(e);

        state = DataState(
          enumSelector: EnumSelector.error,
          message: e.toString(),
        );
      }
    });

    goToQuran = Command.parameter((v) async {
      await _appServices.navigatorState?.pushNamed(
        '/quran',
        arguments: {
          'chapter': v,
        },
      );
    });
  }

  @observable
  ObservableList<Chapters> chapters = ObservableList();

  late Command fetchSurah;

  late Command<Chapters> goToQuran;

  @observable
  DataState state = DataState(
    enumSelector: EnumSelector.none,
  );
}
