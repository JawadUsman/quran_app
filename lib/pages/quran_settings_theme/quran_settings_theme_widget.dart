import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/services/theme_provider.dart';
import 'quran_settings_theme_store.dart';

class QuranSettingsThemeWidget extends StatefulWidget {
  final QuranSettingsThemeStore store;
  const QuranSettingsThemeWidget({
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  _QuranSettingsThemeWidgetState createState() =>
      _QuranSettingsThemeWidgetState();
}

class _QuranSettingsThemeWidgetState extends State<QuranSettingsThemeWidget>
    with BaseStateMixin<QuranSettingsThemeStore, QuranSettingsThemeWidget> {
  @override
  QuranSettingsThemeStore get store => widget.store;

  @override
  Widget build(BuildContext context) {
    (() async {
      await store.getThemes.executeIf();
    })();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: <Widget>[
          ExpandableNotifier(
            initialExpanded: false,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: StreamBuilder<List<ThemeItem>>(
                initialData: store.themes$.valueOrNull,
                stream: store.themes$,
                builder: (
                    BuildContext context,
                    AsyncSnapshot<List<ThemeItem>> snapshot,
                    ) {
                  final themes = snapshot.data ?? [];
                  return StreamBuilder<ThemeItem>(
                    initialData: store.currentTheme$.valueOrNull,
                    stream: store.currentTheme$,
                    builder: (
                        BuildContext context,
                        AsyncSnapshot<ThemeItem> snapshot,
                        ) {
                      final currentTheme = snapshot.data;
                      if (currentTheme == null || themes.length < 2) {
                        return Container();
                      }
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  'Light',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text('Dark',
                                  style: TextStyle(fontSize: 16.0),),
                              ],
                            ),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            buttonPadding: const EdgeInsets.all(2.0),
                            children: <Widget>[
                              Radio<ThemeItem>(
                                value: themes[1],
                                groupValue: currentTheme,
                                activeColor: Colors.blue,
                                onChanged: (val) {
                                  if (val != null) {
                                    store.currentThemeChanged$.add(val);
                                  }
                                },
                              ),
                              Radio<ThemeItem>(
                                value: themes[0],
                                groupValue: currentTheme,
                                activeColor: Colors.blue,
                                onChanged: (val) {
                                  if (val != null) {
                                    store.currentThemeChanged$.add(val);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
