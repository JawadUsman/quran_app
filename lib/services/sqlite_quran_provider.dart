import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/src/locale.dart';
import 'package:quran_app/baselib/app_services.dart';

import 'package:quran_app/models/models.dart';

import 'package:quran_app/models/translation_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import '../main.dart';
import 'quran_provider.dart';

// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: invalid_use_of_protected_member

Database? _quranDb;
Database get quranDb => _quranDb!;

Database? _translationDb;
Database get translationDb => _translationDb!;

class SqliteQuranProvider implements QuranProvider {
  late AssetBundle _assetBundle;
  late AppServices appServices;

  SqliteQuranProvider({
    AssetBundle? assetBundle,
    AppServices? appServices,
  }) {
    _assetBundle = assetBundle ?? sl.get<AssetBundle>()!;
    this.appServices = appServices ?? sl.get<AppServices>()!;
  }

  @override
  Future<Aya> getAya(
    int chapter,
    int aya,
    QuranTextData quranTextData, [
    List<TranslationData>? translations,
  ]) async {
    await initialize();
    var r = await quranDb.rawQuery(
      "select * from '${quranTextData.tableName}' where [sura] == '$chapter' and [aya] == '$aya'",
    );
    var ayaData = r.map((m) {
      var aya = Aya((v) {
        v.indexString = m['sura']?.toString();
        v.text = m['text'] as String? ?? '';
      });
      return aya;
    }).first;
    return ayaData;
  }

  @override
  Future<List<Aya>> getAyaByChapter(int chapter, QuranTextData quranTextData,
      [List<TranslationData>? translations]) async {
    var r = await quranDb.rawQuery(
      "select * from '${quranTextData.tableName}' where [sura] == '$chapter'",
    );
    List<Aya> listAyaHolder = [];
    r.forEach((m) {
      var aya = Aya((v) {
        v.indexString = m['aya']?.toString();
        v.text = m['text'] as String? ?? '';
      });
      listAyaHolder.add(aya);
    });

    List<Aya> listAya = listAyaHolder;
    return listAya;
  }

  @override
  Future<List<Chapters>> getChapters(Locale locale) async {
    var raw = await _assetBundle.loadString(
      'assets/quran-data/chapters/chapters.kan.json',
    );
    Map m = jsonDecode(raw);
    List list = m['chapters'];
    var c = list.map((f) {
      var raw = jsonEncode(f);
      return Chapters.fromJson(raw)!;
    }).toList();
    return c;
  }

  @override
  Future<List<QuranTextData>> getListQuranTextData() {
    final List<QuranTextData> l = [];
    l.add(
      QuranTextData()
        ..tableName = 'quran_uthmani'
        ..name = 'Quran Uthmani',
    );
    return Future.value(l);
  }

  @override
  Future<List<TranslationData>> getListTranslations() async {
    var path = join('assets', 'translations.yaml');
    var listTranslationData =
        await _assetBundle.loadString(path).asStream().map((raw) {
      YamlList jsonList = loadYaml(raw);
      var l = jsonList.map((map) {
        YamlMap yamlMap = map;
        var translationData = TranslationData.fromMap(
          Map<String, dynamic>.from(yamlMap),
        );
        return translationData;
      }).toList();
      return l;
    }).first;
    return listTranslationData;
  }

  @override
  Future<bool> isTableExists(String tableName) async {
    var isExists = (await translationDb.rawQuery(
      'SELECT name FROM sqlite_master WHERE type="table" AND name="${tableName}"',
    ))
        .isNotEmpty;
    return isExists;
  }

  @override
  Future<List<Aya>> getTranslations(
    int chapter,
    TranslationData translationData,
  ) async {
    var tableExists = await isTableExists(translationData.tableName);
    if (!tableExists) {
      return [];
    }

    var rawQuery = await translationDb.rawQuery(
      'SELECT * FROM "${translationData.tableName}" where [sura] == $chapter',
    );
    final List<Aya> l = [];
    rawQuery.forEach((m) {
      var aya = Aya((v) {
        v.indexString = m['ayah']?.toString();
        v.text = m['text'] as String? ?? '';
        v.translationData = translationData;
      });
      l.add(aya);
    });

    return l;
  }

  bool isInitialized = false;

  @override
  Future initialize() async {
    if (isInitialized) {
      appServices.logger.i('Skipped, already initialized');
      return;
    }

    var quranFolder = getQuranFolder(appServices);
    if (!quranFolder.existsSync()) {
      await quranFolder.create();
    }

    {
      {
        var filename = 'quran.db';
        var p = join('assets', 'quran-data', filename);
        var d = await _assetBundle.load(p);
        var localFilePath = join(quranFolder.path, filename);
        var localFile = File(localFilePath);
        if (!localFile.existsSync()) {
          final buffer = d.buffer;
          await localFile.writeAsBytes(
            buffer.asUint8List(d.offsetInBytes, d.lengthInBytes),
            flush: true,
          );
        }
        _quranDb = await openDatabase(localFilePath);
      }

      {
        var translationFilename = 'translations.db';
        var p = join('assets', 'quran-data', translationFilename);
        var d = await _assetBundle.load(p);
        var translationDirectory = Directory(
          quranFolder.path,
        );
        if (!(await translationDirectory.exists())) {
          await translationDirectory.create();
        }
        var localFilePath = join(
          translationDirectory.path,
          translationFilename,
        );
        var localFile = File(localFilePath);
        if (!localFile.existsSync()) {
          final buffer = d.buffer;
          await localFile.writeAsBytes(
            buffer.asUint8List(d.offsetInBytes, d.lengthInBytes),
            flush: true,
          );
        }
        if (_translationDb == null) {
          _translationDb = await openDatabase(localFilePath);
        }
      }
    }

    isInitialized = true;
  }

  @override
  void dispose() {
    if (_quranDb != null) {
      Stream.fromIterable([quranDb])
          .asyncExpand((f) {
            return DeferStream(() {
              return f.close().asStream();
            });
          })
          .take(1)
          .listen(null);
    }
  }

  @override
  Future<Aya?> getTranslation(
    int chapter,
    int aya,
    TranslationData translationData,
  ) async {
    var tableExists = await isTableExists(translationData.tableName);
    if (!tableExists) {
      return null;
    }
    var rawQuery = await translationDb.rawQuery(
      'select * from "${translationData.tableName}" where [sura] == $chapter and [aya] == $aya',
    );
    if (rawQuery.isEmpty) {
      throw ArgumentError('This should be not null');
    }
    var m = rawQuery.first;
    var i = Aya((v) {
      v.indexString = m['aya']?.toString();
      v.text = m['text'] as String? ?? '';
      v.translationData = translationData;
    });
    return i;
  }
}
