import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/disposable.dart';
import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/services/quran_translation_file_provider.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

class QuranSettingsTranslationItemStore implements Disposable {
  late AppServices appServices;
  late QuranTranslationFileProvider quranTranslationFileProvider;

  List<Function> disposeFunction = [];

  QuranSettingsTranslationItemStore(
    TranslationData translationData, {
    AppServices? appServices,
    QuranTranslationFileProvider? quranTranslationFileProvider,
  }) {
    this.translationData = translationData;

    this.appServices = appServices ?? sl.get<AppServices>()!;
    this.quranTranslationFileProvider = quranTranslationFileProvider ??
        sl.get<QuranTranslationFileProvider>()!;

    checkTranslationFile = RxCommand.createAsyncNoParamNoResult(() async {
      try {
        var exists = await this.quranTranslationFileProvider.translationFileExists(
          translationData.tableName,
        );
        this.appServices.logger.i('Translation file exists: $exists');
        translationFileExists.add(exists);
      } catch (e) {
        this.appServices.logger.i(e);
      }
    });

    {
      var dataFile = this.quranTranslationFileProvider.getDataFileById(
        translationData.id,
      );
      if (dataFile != null) {
        var d = dataFile.onChangeStatus.doOnData((v) {
          onChangeStatus.add(v);
        }).listen(null);
        disposeFunction.add(() {
          d.cancel();
        });
      }
    }

    downloadTranslation = Command.parameter((v) async {
      onChangeStatus.add(
        QueueStatusModel()..queueStatus = QueueStatus.downloading,
      );

      var dataFile = this.quranTranslationFileProvider.queueDownload(
        DataFile()
          ..id = translationData.id
          ..url = translationData.uri ?? ''
          ..tableName = translationData.tableName,
      );
      var queueStatus = await dataFile.onChangeStatus.skip(1).take(1).first;
      onChangeStatus.add(queueStatus);
      translationData.isSelected$.add(
        translationData.isSelected$.valueOrNull ?? false,
      );
      checkTranslationFile.execute();
      await checkTranslationFile.next;
    });

    removeTranslation = Command.parameter((t) async {
      if (t != null) {
        await this.quranTranslationFileProvider.removeTranslation(t.tableName);
      }
      checkTranslationFile.execute();
      await checkTranslationFile.next;
      translationData.isSelected$.add(false);
    });
  }

  late TranslationData translationData;

  late RxCommand<void, void> checkTranslationFile;

  final translationFileExists = BehaviorSubject<bool>.seeded(false);

  late Command<QuranSettingsTranslationItemStore> downloadTranslation;

  var onChangeStatus = BehaviorSubject<QueueStatusModel>.seeded(
    QueueStatusModel()..queueStatus = QueueStatus.notDownloaded,
  );

  @override
  bool operator ==(Object other) =>
      other is QuranSettingsTranslationItemStore &&
      other.translationData == translationData;

  @override
  int get hashCode => translationData.hashCode;

  @override
  void dispose() {
    for (var v in disposeFunction) {
      v();
    }
  }

  late Command<TranslationData> removeTranslation;
}
