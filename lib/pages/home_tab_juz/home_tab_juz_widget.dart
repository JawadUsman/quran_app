import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:quran_app/app_widgets/shimmer_loading.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';

import 'home_tab_juz_store.dart';

class HomeTabJuzWidget extends StatefulWidget {
  const HomeTabJuzWidget({Key? key}) : super(key: key);

  @override
  _HomeTabJuzWidgetState createState() => _HomeTabJuzWidgetState();
}

class _HomeTabJuzWidgetState extends State<HomeTabJuzWidget>
    with
        AutomaticKeepAliveClientMixin,
        BaseStateMixin<HomeTabJuzStore, HomeTabJuzWidget> {
  final _store = HomeTabJuzStore();
  @override
  HomeTabJuzStore get store => _store;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.getListJuz.executeIf();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: StreamBuilder<DataState>(
        initialData: store.state$.value,
        stream: store.state$,
        builder: (
            BuildContext context,
            AsyncSnapshot<DataState> snapshot,
            ) {
          return WidgetSelector<DataState>(
            selectedState: snapshot.data ?? DataState.none,
            states: {
              DataState(
                enumSelector: EnumSelector.success,
              ): Observer(
                builder: (BuildContext context) {
                  return ListView.builder(
                    itemCount: store.listJuz.length,
                    itemBuilder: (
                        BuildContext context,
                        int index,
                        ) {
                      var item = store.listJuz[index];
                      var verseMapping =
                      JuzItem.getVerseMappingJuzItem(item.verseMapping);
                      var ayaText = item.listAya?.first.text ?? '';
                      return ListTile(
                        onTap: () {
                          store.juzItemTapped.executeIf(item);
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              '${store.localization.getByKey('home_tab_juz.juz')} ${item.juzNumber}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${item.chapters?.nameSimple ?? ''} ${verseMapping.first.surah}:${verseMapping.first.startAya}',
                              style: const TextStyle(
                                fontFamily: 'Kedage',
                              ),
                            ),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 175,
                          child: Text(
                            ayaText.contains('⁕') ? ayaText.replaceAll('⁕', '').trim() : ayaText,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'noorehira',
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              DataState(
                enumSelector: EnumSelector.loading,
              ): ListView.builder(
                itemCount: 10,
                itemBuilder: (
                    BuildContext context,
                    int index,
                    ) {
                  return const ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ShimmerLoading(
                          height: 10,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ShimmerLoading(
                          height: 10,
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 175,
                      child: ShimmerLoading(
                        height: 20,
                      ),
                    ),
                  );
                },
              ),
            },
          );
        },
      ),
    );
  }
}
