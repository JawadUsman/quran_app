// @dart=2.11
import 'package:flutter/material.dart';
import 'package:quran_app/baselib/base_widgetparameter_mixin.dart';
import 'package:quran_app/routes/routes.dart';
import 'package:quran_app/services/theme_provider.dart';

import 'main_store.dart';

class MainWidget extends StatefulWidget {
  final MainStore mainStore;
  MainWidget({
    @required this.mainStore,
    Key key,
  }) : super(key: key);

  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget>  {
  @override
  void initState() {
    super.initState();

    final store = widget.mainStore;
    store.currentThemeRefresher$.add(null);
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.mainStore;
    return StreamBuilder<ThemeItem>(
      initialData: store.currentTheme$.valueOrNull,
      stream: store.currentTheme$,
      builder: (
        BuildContext context,
        AsyncSnapshot<ThemeItem> snapshot,
      ) {
        final themeMapping = {
          ThemeItem(
            themeType: ThemeType.Light,
          ): ThemeData(
            scaffoldBackgroundColor: Color(0xfff3efd9),
            appBarTheme: AppBarTheme(
              color: Color(0x86000000),
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(
                color: Color(0xff8d642c),
              ),
            ),
          ),
          ThemeItem(
            themeType: ThemeType.Night,
          ): ThemeData.dark().copyWith(
            textTheme: TextTheme(
              bodyText1: TextStyle(
                color: Color(0xffc5c4c3),
              ),
            ),
          )
        };
        var themeData = themeMapping[snapshot.data] ??
            ThemeData(
                scaffoldBackgroundColor: Color(0xfff3efd9),
                appBarTheme: AppBarTheme(
                  color: Color(0x86000000),
                ));

        return MaterialApp(
          title: 'Divya Quran',
          theme: themeData,
          onGenerateRoute: (s) {
            var widgetBuilder = Routes.routes[s.name];
            return MaterialPageRoute(
              builder: (BuildContext context) {
                var widget = widgetBuilder(context);
                if (widget is BaseWidgetParameterMixin) {
                  var baseWidgetParameterMixin = widget;
                  if (s.arguments != null) {
                    baseWidgetParameterMixin.parameter.addAll(
                      Map.from(
                        s.arguments,
                      ),
                    );
                  }
                }
                return widget;
              },
            );
          },
          navigatorKey: store.appServices.navigatorStateKey,
        );
      },
    );
  }
}
