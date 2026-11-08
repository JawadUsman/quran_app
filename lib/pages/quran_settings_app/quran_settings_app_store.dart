import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../main.dart';
import '../quran_settings/quran_settings_store.dart';

part 'quran_settings_app_store.g.dart';

class QuranSettingsAppStore = _QuranSettingsAppStore
    with _$QuranSettingsAppStore;

abstract class _QuranSettingsAppStore extends BaseStore
    with Store
    implements QuranSettingsStoreProvider {
  late ILocalizationService localization;
  late AppServices appServices;

  _QuranSettingsAppStore({
    ILocalizationService? localizationService,
    AppServices? appServices,
  }) {
    localization = localizationService ?? sl.get<ILocalizationService>()!;
    this.appServices = appServices ?? sl.get<AppServices>()!;

    _settingsItems = SettingsItem();

    var _supportedLanguages = localization.getSupportedLanguages();
    localization
        .getSavedLanguage()
        .asStream()
        .doOnData((v) {
          initialiSelectedLanguage.add(v);
          selectedLanguage.add(v);
        })
        .take(1)
        .listen(null);
    supportedLanguages.add(_supportedLanguages);

    {
      var d = selectedLanguage.skip(1).asyncExpand((v) {
        return Rx.defer(() {
          return localization.saveLanguage(v).asStream();
        });
      }).asyncExpand((v) {
        return Rx.defer(() {
          return (this.appServices.navigatorState
              ?.pushNamedAndRemoveUntil(
                '/',
                (_) => false,
              )
              .asStream() ?? const Stream.empty());
        });
      }).listen(null);
      registerDispose(() {
        d.cancel();
      });
    }
  }

  late SettingsItem _settingsItems;
  @override
  SettingsItem get settingsItem => _settingsItems;

  final initialiSelectedLanguage = BehaviorSubject<LanguageModel>();

  final selectedLanguage = BehaviorSubject<LanguageModel>();

  final supportedLanguages = BehaviorSubject<List<LanguageModel>>();
}
