// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appdb.dart';

// ignore_for_file: type=lint
class $QuranBookmarksTable extends QuranBookmarks
    with TableInfo<$QuranBookmarksTable, QuranBookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranBookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _suraMeta = const VerificationMeta('sura');
  @override
  late final GeneratedColumn<int> sura = GeneratedColumn<int>(
      'sura', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _suraNameMeta =
      const VerificationMeta('suraName');
  @override
  late final GeneratedColumn<String> suraName = GeneratedColumn<String>(
      'sura_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ayaMeta = const VerificationMeta('aya');
  @override
  late final GeneratedColumn<int> aya = GeneratedColumn<int>(
      'aya', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _insertTimeMeta =
      const VerificationMeta('insertTime');
  @override
  late final GeneratedColumn<int> insertTime = GeneratedColumn<int>(
      'insert_time', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, sura, suraName, aya, insertTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quran_bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<QuranBookmark> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sura')) {
      context.handle(
          _suraMeta, sura.isAcceptableOrUnknown(data['sura']!, _suraMeta));
    }
    if (data.containsKey('sura_name')) {
      context.handle(_suraNameMeta,
          suraName.isAcceptableOrUnknown(data['sura_name']!, _suraNameMeta));
    }
    if (data.containsKey('aya')) {
      context.handle(
          _ayaMeta, aya.isAcceptableOrUnknown(data['aya']!, _ayaMeta));
    }
    if (data.containsKey('insert_time')) {
      context.handle(
          _insertTimeMeta,
          insertTime.isAcceptableOrUnknown(
              data['insert_time']!, _insertTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranBookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranBookmark(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sura: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sura']),
      suraName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sura_name']),
      aya: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}aya']),
      insertTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}insert_time']),
    );
  }

  @override
  $QuranBookmarksTable createAlias(String alias) {
    return $QuranBookmarksTable(attachedDatabase, alias);
  }
}

class QuranBookmark extends DataClass implements Insertable<QuranBookmark> {
  final int id;
  final int? sura;
  final String? suraName;
  final int? aya;
  final int? insertTime;
  const QuranBookmark(
      {required this.id, this.sura, this.suraName, this.aya, this.insertTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sura != null) {
      map['sura'] = Variable<int>(sura);
    }
    if (!nullToAbsent || suraName != null) {
      map['sura_name'] = Variable<String>(suraName);
    }
    if (!nullToAbsent || aya != null) {
      map['aya'] = Variable<int>(aya);
    }
    if (!nullToAbsent || insertTime != null) {
      map['insert_time'] = Variable<int>(insertTime);
    }
    return map;
  }

  QuranBookmarksCompanion toCompanion(bool nullToAbsent) {
    return QuranBookmarksCompanion(
      id: Value(id),
      sura: sura == null && nullToAbsent ? const Value.absent() : Value(sura),
      suraName: suraName == null && nullToAbsent
          ? const Value.absent()
          : Value(suraName),
      aya: aya == null && nullToAbsent ? const Value.absent() : Value(aya),
      insertTime: insertTime == null && nullToAbsent
          ? const Value.absent()
          : Value(insertTime),
    );
  }

  factory QuranBookmark.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranBookmark(
      id: serializer.fromJson<int>(json['id']),
      sura: serializer.fromJson<int?>(json['sura']),
      suraName: serializer.fromJson<String?>(json['suraName']),
      aya: serializer.fromJson<int?>(json['aya']),
      insertTime: serializer.fromJson<int?>(json['insertTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sura': serializer.toJson<int?>(sura),
      'suraName': serializer.toJson<String?>(suraName),
      'aya': serializer.toJson<int?>(aya),
      'insertTime': serializer.toJson<int?>(insertTime),
    };
  }

  QuranBookmark copyWith(
          {int? id,
          Value<int?> sura = const Value.absent(),
          Value<String?> suraName = const Value.absent(),
          Value<int?> aya = const Value.absent(),
          Value<int?> insertTime = const Value.absent()}) =>
      QuranBookmark(
        id: id ?? this.id,
        sura: sura.present ? sura.value : this.sura,
        suraName: suraName.present ? suraName.value : this.suraName,
        aya: aya.present ? aya.value : this.aya,
        insertTime: insertTime.present ? insertTime.value : this.insertTime,
      );
  QuranBookmark copyWithCompanion(QuranBookmarksCompanion data) {
    return QuranBookmark(
      id: data.id.present ? data.id.value : this.id,
      sura: data.sura.present ? data.sura.value : this.sura,
      suraName: data.suraName.present ? data.suraName.value : this.suraName,
      aya: data.aya.present ? data.aya.value : this.aya,
      insertTime:
          data.insertTime.present ? data.insertTime.value : this.insertTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuranBookmark(')
          ..write('id: $id, ')
          ..write('sura: $sura, ')
          ..write('suraName: $suraName, ')
          ..write('aya: $aya, ')
          ..write('insertTime: $insertTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sura, suraName, aya, insertTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranBookmark &&
          other.id == this.id &&
          other.sura == this.sura &&
          other.suraName == this.suraName &&
          other.aya == this.aya &&
          other.insertTime == this.insertTime);
}

class QuranBookmarksCompanion extends UpdateCompanion<QuranBookmark> {
  final Value<int> id;
  final Value<int?> sura;
  final Value<String?> suraName;
  final Value<int?> aya;
  final Value<int?> insertTime;
  const QuranBookmarksCompanion({
    this.id = const Value.absent(),
    this.sura = const Value.absent(),
    this.suraName = const Value.absent(),
    this.aya = const Value.absent(),
    this.insertTime = const Value.absent(),
  });
  QuranBookmarksCompanion.insert({
    this.id = const Value.absent(),
    this.sura = const Value.absent(),
    this.suraName = const Value.absent(),
    this.aya = const Value.absent(),
    this.insertTime = const Value.absent(),
  });
  static Insertable<QuranBookmark> custom({
    Expression<int>? id,
    Expression<int>? sura,
    Expression<String>? suraName,
    Expression<int>? aya,
    Expression<int>? insertTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sura != null) 'sura': sura,
      if (suraName != null) 'sura_name': suraName,
      if (aya != null) 'aya': aya,
      if (insertTime != null) 'insert_time': insertTime,
    });
  }

  QuranBookmarksCompanion copyWith(
      {Value<int>? id,
      Value<int?>? sura,
      Value<String?>? suraName,
      Value<int?>? aya,
      Value<int?>? insertTime}) {
    return QuranBookmarksCompanion(
      id: id ?? this.id,
      sura: sura ?? this.sura,
      suraName: suraName ?? this.suraName,
      aya: aya ?? this.aya,
      insertTime: insertTime ?? this.insertTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sura.present) {
      map['sura'] = Variable<int>(sura.value);
    }
    if (suraName.present) {
      map['sura_name'] = Variable<String>(suraName.value);
    }
    if (aya.present) {
      map['aya'] = Variable<int>(aya.value);
    }
    if (insertTime.present) {
      map['insert_time'] = Variable<int>(insertTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranBookmarksCompanion(')
          ..write('id: $id, ')
          ..write('sura: $sura, ')
          ..write('suraName: $suraName, ')
          ..write('aya: $aya, ')
          ..write('insertTime: $insertTime')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $QuranBookmarksTable quranBookmarks = $QuranBookmarksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [quranBookmarks];
}

typedef $$QuranBookmarksTableCreateCompanionBuilder = QuranBookmarksCompanion
    Function({
  Value<int> id,
  Value<int?> sura,
  Value<String?> suraName,
  Value<int?> aya,
  Value<int?> insertTime,
});
typedef $$QuranBookmarksTableUpdateCompanionBuilder = QuranBookmarksCompanion
    Function({
  Value<int> id,
  Value<int?> sura,
  Value<String?> suraName,
  Value<int?> aya,
  Value<int?> insertTime,
});

class $$QuranBookmarksTableFilterComposer
    extends Composer<_$AppDb, $QuranBookmarksTable> {
  $$QuranBookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sura => $composableBuilder(
      column: $table.sura, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get suraName => $composableBuilder(
      column: $table.suraName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get aya => $composableBuilder(
      column: $table.aya, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get insertTime => $composableBuilder(
      column: $table.insertTime, builder: (column) => ColumnFilters(column));
}

class $$QuranBookmarksTableOrderingComposer
    extends Composer<_$AppDb, $QuranBookmarksTable> {
  $$QuranBookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sura => $composableBuilder(
      column: $table.sura, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get suraName => $composableBuilder(
      column: $table.suraName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get aya => $composableBuilder(
      column: $table.aya, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get insertTime => $composableBuilder(
      column: $table.insertTime, builder: (column) => ColumnOrderings(column));
}

class $$QuranBookmarksTableAnnotationComposer
    extends Composer<_$AppDb, $QuranBookmarksTable> {
  $$QuranBookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sura =>
      $composableBuilder(column: $table.sura, builder: (column) => column);

  GeneratedColumn<String> get suraName =>
      $composableBuilder(column: $table.suraName, builder: (column) => column);

  GeneratedColumn<int> get aya =>
      $composableBuilder(column: $table.aya, builder: (column) => column);

  GeneratedColumn<int> get insertTime => $composableBuilder(
      column: $table.insertTime, builder: (column) => column);
}

class $$QuranBookmarksTableTableManager extends RootTableManager<
    _$AppDb,
    $QuranBookmarksTable,
    QuranBookmark,
    $$QuranBookmarksTableFilterComposer,
    $$QuranBookmarksTableOrderingComposer,
    $$QuranBookmarksTableAnnotationComposer,
    $$QuranBookmarksTableCreateCompanionBuilder,
    $$QuranBookmarksTableUpdateCompanionBuilder,
    (
      QuranBookmark,
      BaseReferences<_$AppDb, $QuranBookmarksTable, QuranBookmark>
    ),
    QuranBookmark,
    PrefetchHooks Function()> {
  $$QuranBookmarksTableTableManager(_$AppDb db, $QuranBookmarksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuranBookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuranBookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuranBookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> sura = const Value.absent(),
            Value<String?> suraName = const Value.absent(),
            Value<int?> aya = const Value.absent(),
            Value<int?> insertTime = const Value.absent(),
          }) =>
              QuranBookmarksCompanion(
            id: id,
            sura: sura,
            suraName: suraName,
            aya: aya,
            insertTime: insertTime,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> sura = const Value.absent(),
            Value<String?> suraName = const Value.absent(),
            Value<int?> aya = const Value.absent(),
            Value<int?> insertTime = const Value.absent(),
          }) =>
              QuranBookmarksCompanion.insert(
            id: id,
            sura: sura,
            suraName: suraName,
            aya: aya,
            insertTime: insertTime,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$QuranBookmarksTable, QuranBookmark>(table),
                    BaseReferences<_$AppDb, $QuranBookmarksTable,
                        QuranBookmark>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuranBookmarksTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $QuranBookmarksTable,
    QuranBookmark,
    $$QuranBookmarksTableFilterComposer,
    $$QuranBookmarksTableOrderingComposer,
    $$QuranBookmarksTableAnnotationComposer,
    $$QuranBookmarksTableCreateCompanionBuilder,
    $$QuranBookmarksTableUpdateCompanionBuilder,
    (
      QuranBookmark,
      BaseReferences<_$AppDb, $QuranBookmarksTable, QuranBookmark>
    ),
    QuranBookmark,
    PrefetchHooks Function()>;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$QuranBookmarksTableTableManager get quranBookmarks =>
      $$QuranBookmarksTableTableManager(_db, _db.quranBookmarks);
}
