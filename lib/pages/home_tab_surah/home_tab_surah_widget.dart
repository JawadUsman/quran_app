// @dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:quran_app/app_widgets/shimmer_loading.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/pages/error/error_widget.dart';

import 'home_tab_surah_store.dart';

class HomeTabSurahWidget extends StatefulWidget {
  HomeTabSurahWidget({Key key}) : super(key: key);

  _HomeTabSurahWidgetState createState() => _HomeTabSurahWidgetState();
}

class _HomeTabSurahWidgetState extends State<HomeTabSurahWidget>
    with
        AutomaticKeepAliveClientMixin,
        BaseStateMixin<HomeTabSurahStore, HomeTabSurahWidget> {
  final _store = HomeTabSurahStore();
  HomeTabSurahStore get store => _store;

  @override
  void initState() {
    super.initState();

    store.fetchSurah.executeIf();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Observer(
          builder: (BuildContext context) {
            return WidgetSelector<DataState>(
              selectedState: store.state,
              states: {
                DataState(
                  enumSelector: EnumSelector.success,
                ): ListView.builder(
                  shrinkWrap: true,
                  itemExtent: 60,
                  itemCount: store.chapters.length,
                  itemBuilder: (
                      BuildContext context,
                      int index,
                      ) {
                    var item = store.chapters[index];
                    return ListTile(
                      dense:true,
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Stack(
                              alignment:
                              Alignment.center,
                              children: <Widget>[
                                Container(
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/ayah-background.png'),
                                      color: Theme.of(context).textTheme.bodyText1.color,
                                      width: 44.0,
                                      height: 45.0,
                                      fit: BoxFit.fill,
                                    )),
                                Container(
                                  alignment: Alignment
                                      .center,
                                  child: Text(
                                    '${item.chapterNumber}',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                      title: Text(
                        item.nameSimple,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'kannada',
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            item.nameArabic,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 21,
                              fontFamily: 'noorehira',
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        store.goToQuran.executeIf(item);
                      },
                    );
                  },
                ),
                DataState(
                  enumSelector: EnumSelector.loading,
                ): ListView.builder(
                  itemCount: 11,
                  itemBuilder: (
                      BuildContext context,
                      int index,
                      ) {
                    return ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 28,
                            width: 32,
                            child: ShimmerLoading(),
                          ),
                        ],
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            height: 25,
                            child: ShimmerLoading(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 22,
                            child: ShimmerLoading(),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 28,
                            child: ShimmerLoading(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                DataState(
                  enumSelector: EnumSelector.error,
                ): Center(
                  child: MyErrorWidget(
                    message: store.state.message,
                  ),
                ),
              },
            );
          },
        ),
      ),
    );
  }
}
