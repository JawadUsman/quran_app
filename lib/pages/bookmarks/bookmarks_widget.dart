import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:quran_app/app_widgets/shimmer_loading.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/services/appdb.dart';

import 'bookmarks_store.dart';

class BookmarksWidget extends StatefulWidget {
  const BookmarksWidget({Key? key}) : super(key: key);

  @override
  _BookmarksWidgetState createState() => _BookmarksWidgetState();
}

class _BookmarksWidgetState extends State<BookmarksWidget>
    with BaseStateMixin<BookmarksStore, BookmarksWidget> {
  final _store = BookmarksStore();
  @override
  BookmarksStore get store => _store;

  @override
  Widget build(BuildContext context) {
    store.getBookmarks.execute();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          store.localization.getByKey(
            'bookmarks.title',
          ),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: StreamBuilder<DataState>(
          initialData: store.bookmarkState.valueOrNull,
          stream: store.bookmarkState,
          builder: (
              BuildContext context,
              AsyncSnapshot<DataState> snapshot,
              ) {
            return WidgetSelector<DataState>(
              selectedState: snapshot.data ?? DataState.none,
              states: {
                DataState.success: Container(
                  child: StreamBuilder<List<QuranBookmark>>(
                    initialData: store.bookmarks.valueOrNull,
                    stream: store.bookmarks,
                    builder: (
                        BuildContext context,
                        AsyncSnapshot<List<QuranBookmark>> snapshot,
                        ) {
                      var list = store.bookmarks.valueOrNull ?? [];
                      if (list.isEmpty) {
                        return Container(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  store.localization.getByKey(
                                    'bookmarks.no_bookmarks',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (
                            BuildContext context,
                            int index,
                            ) {
                          var item = list[index];

                          return ListTile(
                            dense: true,
                            onTap: () {
                              store.goToQuran.execute(item);
                            },
                            title: Container(
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Text(
                                          '${item.suraName} ${item.sura}:${item.aya}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Kedage',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    intl.DateFormat(
                                      'yMMMMd',
                                      store.localization.locale?.toLanguageTag(),
                                    ).format(
                                      item.insertDateTime,
                                    ),
                                    textDirection: TextDirection.rtl,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(0),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    store.removeBookmark.execute(item);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 10,
                                    ),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Icon(Icons.delete),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                DataState.loading: Container(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (
                        BuildContext context,
                        int index,
                        ) {
                      return const ListTile(
                        dense: true,
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  ShimmerLoading(
                                    height: 18,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ShimmerLoading(
                              height: 18,
                            ),
                          ],
                        ),
                      );
                    },
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
