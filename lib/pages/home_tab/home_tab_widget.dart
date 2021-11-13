// @dart=2.11
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/base_widgetparameter_mixin.dart';
import 'package:quran_app/pages/bookmarks/bookmarks_widget.dart';
import 'package:quran_app/pages/help/help_widget.dart';
import 'package:quran_app/pages/home_tab/home_tab_store.dart';
import 'package:quran_app/pages/home_tab_juz/home_tab_juz_widget.dart';
import 'package:quran_app/pages/home_tab_surah/home_tab_surah_widget.dart';

import 'home_tab_store.dart';

class HomeTabWidget extends StatefulWidget with BaseWidgetParameterMixin {
  HomeTabWidget({Key key}) : super(key: key);

  _HomeTabWidgetState createState() => _HomeTabWidgetState();
}

class _HomeTabWidgetState extends State<HomeTabWidget>
    with BaseStateMixin<HomeTabStore, HomeTabWidget>, TickerProviderStateMixin {
  final _store = HomeTabStore();
  @override
  HomeTabStore get store => _store;

  @override
  bool get wantKeepAlive => true;

  TabController tabController;
  PageController pageTabController;

  TabController quranTabController;
  PageController pageQuranTabController;
  final List<Widget Function()> pagesQuranTab = [
    () => HomeTabSurahWidget(),
    () => HomeTabJuzWidget(),
  ];

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 2,
      vsync: this,
    );
    pageTabController = PageController();
    tabController.addListener(() {
      pageTabController.jumpToPage(tabController.index);
    });

    quranTabController = TabController(
      length: 2,
      vsync: this,
    );
    pageQuranTabController = PageController();
    quranTabController.addListener(() {
      pageQuranTabController.jumpToPage(quranTabController.index);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    quranTabController.dispose();
    pageTabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            store.localization.getByKey('AppName'),
          ),
        ),
        bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
        body: PageStorage(
          bucket: bucket,
          child: <Widget>[
            Container(
              child: HomeTabSurahWidget(),
            ),
            Container(
              child: HomeTabJuzWidget(),
            ),
            Container(
              child: BookmarksWidget(),
            ),
            Container(
              child: HelpWidget(),
            ),
          ][_selectedIndex],
        ),
      ),
    );
  }

  final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
    onTap: (int index) => setState(() => _selectedIndex = index),
    currentIndex: selectedIndex,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Color(0x86000000),
    unselectedItemColor: Color(0x35ffffff),
    selectedItemColor: Color(0xffffffff),
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.bookOpen),
        title: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Surahs',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
              ),
            )),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.chartPie),
        title: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Juz\'',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
              ),
            )),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.solidBookmark),
        title: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Bookmarks',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
              ),
            )),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.infoCircle),
        title: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'About Us',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
              ),
            )),
      ),
    ],
  );
}
