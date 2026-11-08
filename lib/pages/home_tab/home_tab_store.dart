import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/localization_service.dart';

import '../../main.dart';

part 'home_tab_store.g.dart';

class HomeTabStore = _HomeTabStore with _$HomeTabStore;

abstract class _HomeTabStore extends BaseStore with Store {
  late ILocalizationService localization;

  _HomeTabStore({
    ILocalizationService? localization,
  }) {
    this.localization = localization ?? sl.get<ILocalizationService>()!;
  }
}
