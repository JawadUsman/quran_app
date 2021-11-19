// @dart=2.11
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/base_widgetparameter_mixin.dart';
import 'splash_store.dart';

class SplashWidget extends StatefulWidget with BaseWidgetParameterMixin {
  SplashWidget({Key key}) : super(key: key);

  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget>
    with BaseStateMixin<SplashStore, SplashWidget> {
  final _store = SplashStore();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      print("Jawad update info: $info");
      info.updateAvailability == UpdateAvailability.updateAvailable
          ? () {
              InAppUpdate.performImmediateUpdate()
                  .catchError((e) => navigateToHomeScreen());
            }
          : navigateToHomeScreen();
    }).catchError((e) {
      print("Jawad update info error: $e");
      navigateToHomeScreen();
    });
  }

  @override
  SplashStore get store => _store;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      checkForUpdate();
    } else
      navigateToHomeScreen();
  }

  void navigateToHomeScreen() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          store.initialize.execute();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/divya-quran.png'),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
