import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/services/quran_provider.dart';
import '../../baselib/localization_service.dart';

import '../../baselib/app_services.dart';
import '../../baselib/base_store.dart';
import '../../main.dart';

part 'splash_store.g.dart';

class SplashStore = _SplashStore with _$SplashStore;

abstract class _SplashStore extends BaseStore with Store {
  late AppServices _appServices;
  late ILocalizationService _localizationService;
  late QuranProvider _quranProvider;

  _SplashStore({
    AppServices? appServices,
    ILocalizationService? localizationService,
    QuranProvider? quranProvider,
  }) {
    _appServices = appServices ?? sl.get<AppServices>()!;
    _localizationService = localizationService ?? sl.get<ILocalizationService>()!;
    _quranProvider = quranProvider ?? sl.get<QuranProvider>()!;

    initialize = Command(() async {
      await _appServices.initialize();

      await _quranProvider.initialize();

      var language = await _localizationService.getSavedLanguage();
      await _localizationService.loadFromBundle(
        language.locale,
      );

      await _appServices.navigatorState?.pushNamedAndRemoveUntil(
        '/home',
        (_) => false,
      );
    });
  }

  late Command initialize;
}
