// @dart=2.11
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/pages/quran_settings_fontsizes/quran_settings_fontsizes_store.dart';

class QuranSettingsFontSizesWidget extends StatefulWidget {
  final QuranSettingsFontsizesStore store;
  QuranSettingsFontSizesWidget({
    @required this.store,
    Key key,
  }) : super(key: key);

  _QuranSettingsFontSizesWidgetState createState() =>
      _QuranSettingsFontSizesWidgetState();
}

class _QuranSettingsFontSizesWidgetState
    extends State<QuranSettingsFontSizesWidget>
    with
        BaseStateMixin<QuranSettingsFontsizesStore,
            QuranSettingsFontSizesWidget> {
  @override
  QuranSettingsFontsizesStore get store => widget.store;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: <Widget>[
          StreamBuilder<double>(
              initialData: store.arabicFontSize$.value,
              stream: store.arabicFontSize$,
              builder: (
                  BuildContext context,
                  AsyncSnapshot<double> snapshot,
                  ) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child:
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            store.localization.getByKey(
                              'quran_settings_fontsizes.arabic_fontsize',
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 120.0,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                                style: TextStyle(
                                  fontFamily: 'noorehira',
                                  fontSize: store.arabicFontSize$.value,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            )),
                        StreamBuilder<double>(
                          initialData: store.arabicFontSize$.value,
                          stream: store.arabicFontSize$,
                          builder: (
                              BuildContext context,
                              AsyncSnapshot<double> snapshot,
                              ) {
                            return Slider(
                              min: 20,
                              max: 100,
                              value: snapshot.data,
                              onChanged: (double value) {
                                store.arabicFontSizeChanged$.add(value);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
          StreamBuilder<double>(
              initialData: store.translationFontSize$.value,
              stream: store.translationFontSize$,
              builder: (
                  BuildContext context,
                  AsyncSnapshot<double> snapshot,
                  ) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              store.localization.getByKey(
                                'quran_settings_fontsizes.translation_fontsize',
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: 120.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'ಪರಮ ದಯಾಮಯನೂ ಕರುಣಾಳುವೂ ಆದ ಅಲ್ಲಾಹನ ನಾಮದಿಂದ',
                                  style: TextStyle(
                                    fontSize: store.translationFontSize$.value,
                                  ),
                                ),
                              )),
                          StreamBuilder<double>(
                            initialData: store.translationFontSize$.value,
                            stream: store.translationFontSize$,
                            builder: (
                                BuildContext context,
                                AsyncSnapshot<double> snapshot,
                                ) {
                              return Slider(
                                min: 20,
                                max: 100,
                                value: snapshot.data,
                                onChanged: (double value) {
                                  store.translationFontSizeChanged$.add(value);
                                },
                              );
                            },
                          )
                        ],
                      )),
                );
              }),
        ],
      ),
    );
  }
}