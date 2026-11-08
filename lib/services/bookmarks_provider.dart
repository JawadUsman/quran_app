import 'package:drift/drift.dart';

import '../main.dart';
import 'appdb.dart';

class BookmarksRequest {}

abstract class BookmarksProvider {
  Future<QuranBookmark?> getItem(int aya, int sura);

  Future<List<QuranBookmark>> getItems(BookmarksRequest request);

  Future<int> addItem(QuranBookmarksCompanion item);

  Future<int> removeItem(QuranBookmark item);

  Future<bool> udpateItem(QuranBookmark item);
}

class SqliteBookmarksProvider implements BookmarksProvider {
  late AppDb appDb;

  SqliteBookmarksProvider({
    AppDb? appDb,
  }) {
    this.appDb = (appDb ?? sl.get<AppDb>())!;
  }

  @override
  Future<QuranBookmark?> getItem(int aya, int sura) async {
    var l = await (appDb.select(appDb.quranBookmarks)
          ..where((t) {
            return t.sura.equals(sura) & t.aya.equals(aya);
          }))
        .get();
    if (l.isEmpty) return null;
    return l.first;
  }

  @override
  Future<List<QuranBookmark>> getItems(BookmarksRequest request) async {
    var l = await (appDb.select(appDb.quranBookmarks)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.insertTime,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();
    return l;
  }

  @override
  Future<int> addItem(QuranBookmarksCompanion item) async {
    var suraVal = item.sura.value;
    var ayaVal = item.aya.value;
    if (suraVal != null && ayaVal != null) {
      var existingItem = await (appDb.select(appDb.quranBookmarks)
            ..where(
              (t) =>
                  t.sura.equals(suraVal) & t.aya.equals(ayaVal),
            ))
          .get();
      if (existingItem.isNotEmpty) {
        return -1;
      }
    }

    var id = await appDb.into(appDb.quranBookmarks).insert(item);
    return id;
  }

  @override
  Future<int> removeItem(QuranBookmark item) async {
    var id = await (appDb.delete(appDb.quranBookmarks)
          ..where(
            (t) => t.id.equals(item.id),
          ))
        .go();
    return id;
  }

  @override
  Future<bool> udpateItem(QuranBookmark item) async {
    var b = await appDb.update(appDb.quranBookmarks).replace(item);
    return b;
  }
}
