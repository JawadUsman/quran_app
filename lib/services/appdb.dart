import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'appdb.g.dart';

class QuranBookmarks extends Table {
  IntColumn get id => integer()();
  IntColumn get sura => integer().nullable()();
  TextColumn get suraName => text().nullable()();
  IntColumn get aya => integer().nullable()();
  IntColumn get insertTime => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [QuranBookmarks])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'appdb.sqlite'));
    return NativeDatabase(file);
  });
}

extension QuranBookmarkExtension on QuranBookmark {
  DateTime get insertDateTime {
    var dateTime = DateTime.fromMicrosecondsSinceEpoch(this.insertTime ?? 0);
    return dateTime;
  }
}
