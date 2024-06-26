import 'package:flutter/material.dart';
import 'package:quran_app/pages/dua_khatm_ul_quran/dua_khatm_ul_quran.dart';
import 'package:quran_app/pages/home/home_widget.dart';
import 'package:quran_app/pages/quran/quran_widget.dart';
import 'package:quran_app/pages/splash/splash_widget.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => SplashWidget(),
    '/home': (context) => HomeWidget(),
    '/quran': (context) => QuranWidget(),
    '/dua': (context) => DuaKhatmUlQuranWidget(),
  };
}
