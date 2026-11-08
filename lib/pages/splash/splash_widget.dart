import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/base_widgetparameter_mixin.dart';
import 'splash_store.dart';

class SplashWidget extends StatefulWidget with BaseWidgetParameterMixin {
  SplashWidget({Key? key}) : super(key: key);

  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget>
    with BaseStateMixin<SplashStore, SplashWidget> {
  final _store = SplashStore();

  Future<void> checkForUpdate() async {
    try {
      var info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        try {
          await InAppUpdate.performImmediateUpdate();
        } catch (_) {
          navigateToHomeScreen();
        }
      } else {
        navigateToHomeScreen();
      }
    } catch (_) {
      navigateToHomeScreen();
    }
  }

  @override
  SplashStore get store => _store;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      checkForUpdate();
    } else {
      navigateToHomeScreen();
    }
  }

  void navigateToHomeScreen() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            store.initialize.execute();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/divya-quran.png'),
                  fit: BoxFit.fill)),
        ),
      ),
    );
  }
}
