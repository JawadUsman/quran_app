import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/services/theme_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore extends BaseStore with Store {
  late ILocalizationService localizationService;
  late AppServices appServices;
  late ThemeProviderImplementation themeProvider;

  _MainStore({
    ILocalizationService? localizationService,
    AppServices? appServices,
    ThemeProviderImplementation? themeProvider,
  }) {
    this.localizationService =
        localizationService ?? sl.get<ILocalizationService>()!;
    this.appServices = appServices ?? sl.get<AppServices>()!;
    this.themeProvider = themeProvider ?? sl.get<ThemeProviderImplementation>()!;

    getCurrentTheme = Command(() async {
      var currentTheme = await this.themeProvider.getCurrentTheme();
      currentTheme$.add(currentTheme);
    });

    CompositeSubscription? ds = CompositeSubscription();

    ds.add(this.themeProvider.themeChanged.map((_) => null).mergeWith([
      currentThemeRefresher$.map(
        (_) => null,
      ),
    ]).asyncExpand((_) {
      return getCurrentTheme.executeIf().asStream();
    }).listen(null));

    registerDispose(() {
      ds?.dispose();
      ds = null;
    });
  }

  final currentThemeRefresher$ = PublishSubject<void>(
    sync: true,
  );

  final currentTheme$ = BehaviorSubject<ThemeItem>(
    sync: true,
  );

  late Command getCurrentTheme;
}
