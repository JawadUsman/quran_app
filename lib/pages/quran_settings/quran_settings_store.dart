// @dart=2.11
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/pages/quran_settings_fontsizes/quran_settings_fontsizes_store.dart';
import 'package:quran_app/pages/quran_settings_fontsizes/quran_settings_fontsizes_widget.dart';
import 'package:quran_app/pages/quran_settings_theme/quran_settings_theme_store.dart';
import 'package:quran_app/pages/quran_settings_theme/quran_settings_theme_widget.dart';
import 'package:tuple/tuple.dart';

import '../../main.dart';
part 'quran_settings_store.g.dart';

class SettingsItem {
  String name;
}

abstract class QuranSettingsStoreProvider<T> {
  SettingsItem get settingsItem;
}

class QuranSettingsStore = _QuranSettingsStore with _$QuranSettingsStore;

abstract class _QuranSettingsStore extends BaseStore with Store {
  var localization = sl.get<ILocalizationService>();

  _QuranSettingsStore({
    @required Map<Type, Object> parameter,
    ILocalizationService localizationService,
  }) {
    this.localization =
        localizationService ?? (localizationService = this.localization);
    {
      {
        final store = QuranSettingsFontsizesStore(
          parameter: parameter,
        );
        items.add(
          Tuple2(
            QuranSettingsFontSizesWidget(
              store: store,
            ),
            store,
          ),
        );
      }
      {
        final store = QuranSettingsThemeStore();
        items.add(
          Tuple2(
            QuranSettingsThemeWidget(
              store: store,
            ),
            store,
          ),
        );
      }
    }
  }

  List<Tuple2<Widget, QuranSettingsStoreProvider>> items = [];
}
