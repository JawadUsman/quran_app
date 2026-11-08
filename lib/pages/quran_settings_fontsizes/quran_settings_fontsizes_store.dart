import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../extensions/settings_extension.dart';

import '../../main.dart';
import '../quran_settings/quran_settings_store.dart';

part 'quran_settings_fontsizes_store.g.dart';

class QuranSettingsFontsizesStore = _QuranSettingsFontsizesStore
    with _$QuranSettingsFontsizesStore;

abstract class _QuranSettingsFontsizesStore extends BaseStore
    with Store
    implements QuranSettingsStoreProvider {
  late ILocalizationService localization;

  _QuranSettingsFontsizesStore({
    required Map<Type, Object> parameter,
  }) {
    this.localization = sl.get<ILocalizationService>()!;
    _settingsItems = SettingsItem();

    if (parameter[QuranSettingsFontsizesStore] != null) {
      Map<String, Object> p = parameter[QuranSettingsFontsizesStore] as Map<String, Object>;
      _arabicFontSize$ = p['arabicFontSize'] as BehaviorSubject<double>;
      _translationFontSize$ = p['translationFontSize'] as BehaviorSubject<double>;
    }

    CompositeSubscription? ds = CompositeSubscription();

    ds.add(arabicFontSizeChanged$
        .doOnData((v) {
          arabicFontSize$.add(v);
        })
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap((v) {
          return DeferStream(() {
            return rxPrefs.setArabicFontSize(v).asStream();
          });
        })
        .listen(null));

    ds.add(translationFontSizeChanged$
        .doOnData((v) {
          translationFontSize$.add(v);
        })
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap((v) {
          return DeferStream(() {
            return rxPrefs.setTranslationFontSize(v).asStream().map((_) => v);
          });
        })
        .listen(null));

    registerDispose(() {
      ds?.dispose();
      ds = null;
    });
  }

  late SettingsItem _settingsItems;
  @override
  SettingsItem get settingsItem => _settingsItems;

  late BehaviorSubject<double> _arabicFontSize$;
  BehaviorSubject<double> get arabicFontSize$ => _arabicFontSize$;

  final arabicFontSizeChanged$ = PublishSubject<double>();

  late BehaviorSubject<double> _translationFontSize$;
  BehaviorSubject<double> get translationFontSize$ => _translationFontSize$;

  final translationFontSizeChanged$ = PublishSubject<double>();
}
