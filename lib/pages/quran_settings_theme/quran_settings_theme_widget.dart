// @dart=2.11
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/services/theme_provider.dart';
import 'quran_settings_theme_store.dart';

class QuranSettingsThemeWidget extends StatefulWidget {
  final QuranSettingsThemeStore store;
  QuranSettingsThemeWidget({
    @required this.store,
    Key key,
  }) : super(key: key);

  _QuranSettingsThemeWidgetState createState() =>
      _QuranSettingsThemeWidgetState();
}

class _QuranSettingsThemeWidgetState extends State<QuranSettingsThemeWidget>
    with BaseStateMixin<QuranSettingsThemeStore, QuranSettingsThemeWidget> {
  @override
  QuranSettingsThemeStore get store => widget.store;

  @override
  Widget build(BuildContext context) {
    // initState only called once, try to change the theme
    (() async {
      await store.getThemes.executeIf();
    })();

    return Container(
      padding: EdgeInsets.symmetric(
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
                  final themes = snapshot.data;
                  return StreamBuilder<ThemeItem>(
                    initialData: store.currentTheme$.valueOrNull,
                    stream: store.currentTheme$,
                    builder: (
                        BuildContext context,
                        AsyncSnapshot<ThemeItem> snapshot,
                        ) {
                      final currentTheme = snapshot.data;
                      if (currentTheme == null) {
                        return Container();
                      }
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
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
                            buttonPadding: EdgeInsets.all(2.0),
                            children: <Widget>[
                              Radio(
                                value: themes[1],
                                groupValue: currentTheme,
                                activeColor: Colors.blue,
                                onChanged: (val) {
                                  store.currentThemeChanged$.add(val);
                                },
                              ),
                              Radio(
                                value: themes[0],
                                groupValue: currentTheme,
                                activeColor: Colors.blue,
                                onChanged: (val) {
                                  store.currentThemeChanged$.add(val);
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
