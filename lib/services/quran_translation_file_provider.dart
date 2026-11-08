import 'package:flutter/services.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart';

import '../main.dart';
import 'sqlite_quran_provider.dart';

abstract class QuranTranslationFileProvider {
  Future<bool> translationFileExists(String tableName);

  DataFile queueDownload(DataFile dataFile);

  DataFile? getDataFileById(String id);

  Future removeTranslation(String tableName);
}

class QuranTranslationFileProviderImplementation
    implements QuranTranslationFileProvider {
  late AssetBundle assetBundle;
  late AppServices appServices;
  late QuranProvider quranProvider;
  var dio = Dio();

  QuranTranslationFileProviderImplementation({
    AssetBundle? assetBundle,
    AppServices? appServices,
    QuranProvider? quranProvider,
  }) {
    this.assetBundle = assetBundle ?? sl.get<AssetBundle>()!;
    this.appServices = appServices ?? sl.get<AppServices>()!;
    this.quranProvider = quranProvider ?? sl.get<QuranProvider>()!;

    downloadSubject.doOnData((v) {
      if (!currentQueued.contains(v)) {
        currentQueued.add(v);
      }
      v._onChangeStatus.add(
        QueueStatusModel()..queueStatus = QueueStatus.downloading,
      );
    }).flatMap((dataFile) {
      return Future.microtask(() async {
        try {
          var raw = await dio.get<String>(dataFile.url,
              options: Options(
                responseType: ResponseType.plain,
              ));
          var d = XmlDocument.parse(raw.data ?? '');
          var suraElements = d.findAllElements('sura');
          var index = 0;
          var items = suraElements.expand((f) {
            var x = f.findAllElements('aya');
            return x.map((v) {
              index++;
              var i = _ItemModel()
                ..index = index
                ..sura = int.tryParse(f.getAttribute('index') ?? '')
                ..aya = int.tryParse(v.getAttribute('index') ?? '')
                ..text = v.getAttribute('text');
              return i;
            });
          }).toList();
          await removeTranslation(dataFile.tableName);
          await translationDb.transaction((txn) async {
            await txn.execute("""
            CREATE TABLE "${dataFile.tableName}" (
              "index"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              "sura"	INTEGER NOT NULL DEFAULT 0,
              "aya"	INTEGER NOT NULL DEFAULT 0,
              "text"	TEXT NOT NULL
            );
            """);
            var batch = txn.batch();
            for (var item in items) {
              batch.insert(dataFile.tableName, {
                'index': item.index,
                'sura': item.sura,
                'aya': item.aya,
                'text': item.text,
              });
            }
            await batch.commit(
              noResult: true,
            );
          });

          dataFile._onChangeStatus.add(
            QueueStatusModel()..queueStatus = QueueStatus.downloaded,
          );
          currentQueued.remove(dataFile);
        } catch (e) {
          print(e);

          dataFile._onChangeStatus.add(
            QueueStatusModel()
              ..queueStatus = QueueStatus.error
              ..status = e.toString(),
          );
        }

        return dataFile;
      }).asStream();
    }).listen(null);
  }

  @override
  Future<bool> translationFileExists(String tableName) async {
    var exists = await quranProvider.isTableExists(tableName);
    return exists;
  }

  @override
  DataFile queueDownload(DataFile dataFile) {
    downloadSubject.add(dataFile);
    return dataFile;
  }

  @override
  Future removeTranslation(String tableName) async {
    await translationDb.execute(
      'DROP TABLE IF EXISTS "${tableName}"',
    );
  }

  var downloadSubject = PublishSubject<DataFile>();

  List<DataFile> currentQueued = [];

  @override
  DataFile? getDataFileById(String id) {
    if (currentQueued.any((t) => t.id == id)) {
      return currentQueued.firstWhere((t) => t.id == id);
    }
    return null;
  }
}

class _ItemModel {
  int? index;
  int? sura;
  int? aya;
  String? text;
}

enum QueueStatus {
  queued,
  downloading,
  downloaded,
  notDownloaded,
  error,
}

class QueueStatusModel {
  late QueueStatus queueStatus;
  String? status;

  @override
  bool operator ==(Object other) => other is QueueStatusModel && queueStatus == other.queueStatus;

  @override
  int get hashCode => queueStatus.hashCode;
}

class DataFile {
  late String id;
  late String url;
  late String tableName;

  final _onChangeStatus = BehaviorSubject<QueueStatusModel>();

  Stream<QueueStatusModel> get onChangeStatus => _onChangeStatus;

  final _onReceiveDataFile = BehaviorSubject<DataFile>();

  Stream<DataFile> get onReceiveDataFile => _onReceiveDataFile;

  String? status;

  @override
  bool operator ==(Object other) => other is DataFile && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
