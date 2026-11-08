import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/services/appdb.dart';
import 'package:quran_app/services/bookmarks_provider.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

part 'bookmarks_store.g.dart';

class BookmarksStore = _BookmarksStore with _$BookmarksStore;

abstract class _BookmarksStore extends BaseStore with Store {
  late ILocalizationService localization;
  late BookmarksProvider bookmarkProvider;
  late AppServices appServices;

  _BookmarksStore({
    ILocalizationService? localizationService,
    BookmarksProvider? bookmarksProvider,
    AppServices? appServices,
  }) {
    this.localization =
        localizationService ?? sl.get<ILocalizationService>()!;
    this.bookmarkProvider =
        bookmarksProvider ?? sl.get<BookmarksProvider>()!;
    this.appServices = appServices ?? sl.get<AppServices>()!;

    getBookmarks = RxCommand.createAsyncNoParamNoResult(() async {
      bookmarkState.add(DataState.loading);

      var items = await bookmarkProvider.getItems(BookmarksRequest());
      bookmarks.add(items);

      bookmarkState.add(DataState.success);
    });

    removeBookmark = RxCommand.createAsyncNoResult(
      (QuranBookmark item) async {
        var id = await bookmarkProvider.removeItem(item);
        this.appServices.logger.i('Removed item id: $id');

        var current = bookmarks.valueOrNull ?? [];
        var newList = (List<QuranBookmark>.from(current)..remove(item));
        bookmarks.add(newList);
      },
    );

    goToQuran = RxCommand.createAsyncNoResult((QuranBookmark v) async {
      await this.appServices.navigatorState?.pushNamed(
        '/quran',
        arguments: {
          'chapter': Chapters((f) {
            f.chapterNumber = v.sura;
            f.nameSimple = v.suraName;
          }),
          'aya': v.aya,
        },
      );
    });
  }

  late RxCommand<void, void> getBookmarks;

  final bookmarkState = BehaviorSubject<DataState>.seeded(
    DataState.none,
  );

  final bookmarks = BehaviorSubject<List<QuranBookmark>>();

  late RxCommand<QuranBookmark, void> removeBookmark;

  late RxCommand<QuranBookmark, void> goToQuran;
}
