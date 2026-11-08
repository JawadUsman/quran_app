import 'dart:async';
import 'dart:io';

import 'package:animator/animator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_app/services/preferences_utils.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:quran_app/app_widgets/shimmer_loading.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/base_widgetparameter_mixin.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/pages/quran/quran_store.dart';
import 'package:quiver/strings.dart';
import 'package:quran_app/pages/quran_navigator/quran_navigator_store.dart';
import 'package:quran_app/pages/quran_navigator/quran_navigator_widget.dart';
import 'package:quran_app/pages/quran_settings/quran_settings_widget.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import '../quran_settings/quran_settings_store.dart';
import 'player_state.dart';

class QuranWidget extends StatefulWidget with BaseWidgetParameterMixin {
  QuranWidget({Key? key}) : super(key: key);

  @override
  _QuranWidgetState createState() => _QuranWidgetState();
}

class _QuranWidgetState extends State<QuranWidget>
    with
        BaseStateMixin<QuranStore, QuranWidget>,
        AutomaticKeepAliveClientMixin {
  late QuranStore _store;

  @override
  QuranStore get store => _store;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _store = QuranStore(
      parameter: widget.parameter,
    );

    {
      var d = _store.pickQuranNavigatorInteraction.registerHandler((p) async {
        var r = await showDialog(
          context: context,
          builder: (context) {
            return QuranNavigatorWidget(
              store: QuranNavigatorStore(
                parameter: p,
              ),
            );
          },
        );
        return r as Map<String, Object>?;
      });
      _store.registerDispose(() {
        d.dispose();
      });
    }
  }

  Widget circularProgress(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(cardColor: const Color(0xffe1d79f)),
        child: const CircularProgressIndicator(
          strokeWidth: 2.0,
          backgroundColor: Color(0x86000000),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      drawerEdgeDragWidth: 0,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: InkWell(
          onTap: () async {
            store.pickQuranNavigator.executeIf();
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<Chapters>(
                  initialData: store.selectedChapter$.valueOrNull,
                  stream: store.selectedChapter$,
                  builder:
                      (BuildContext context, AsyncSnapshot<Chapters> snapshot) {
                    var selectedChapter = snapshot.data;
                    if (selectedChapter == null) {
                      return Container();
                    }
                    return Text(
                      '${selectedChapter.chapterNumber}. ${selectedChapter.nameSimple}',
                    );
                  },
                ),
                const Icon(
                  Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              {
                var d = store.showSettingsInteraction.registerHandler((_) {
                  Scaffold.of(context).openEndDrawer();
                  return Future.value();
                });
                _store.registerDispose(() {
                  d.dispose();
                });
              }

              return IconButton(
                onPressed: () {
                  _store.showSettings.executeIf();
                },
                icon: const Icon(Icons.settings),
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Builder(
          builder: (BuildContext context) {
            return QuranSettingsWidget(
              store: QuranSettingsStore(
                parameter: store.settingsParameter,
              ),
            );
          },
        ),
      ),
      body: StreamBuilder<DataState>(
        initialData: store.state$.value,
        stream: store.state$,
        builder: (
          BuildContext context,
          AsyncSnapshot<DataState> snapshot,
        ) {
          if (EnumSelector.success == _store.state$.value.enumSelector) {
            var audioUrl = _store.selectedChapter$.valueOrNull?.audioURL ?? '';
            setMediaURL(audioUrl);
          }
          return WidgetSelector<DataState>(
            selectedState: snapshot.data ?? DataState.none,
            states: {
              DataState(
                enumSelector: EnumSelector.success,
              ): Container(
                child: Observer(
                  builder: (BuildContext context) {
                    var itemIndex = store.listAya.indexWhere(
                      (t) => t.aya.valueOrNull == store.initialSelectedAya$.valueOrNull,
                    );
                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: Scrollbar(
                            child: ScrollablePositionedList.builder(
                              itemCount: store.listAya.length,
                              initialScrollIndex:
                                  itemIndex >= 0 ? itemIndex : 0,
                              addAutomaticKeepAlives: true,
                              itemBuilder: (
                                BuildContext context,
                                int index,
                              ) {
                                if (store.listAya.isEmpty) {
                                  return Container();
                                }
                                var item = store.listAya[index];
                                item.getTranslations.execute();
                                item.getBookmark.execute();
                                var aya = item.aya.value;
                                var ruku = aya.ruku == 1;
                                return StreamBuilder<bool>(
                                  initialData: item.isBookmarked.value,
                                  stream: item.isBookmarked,
                                  builder: (
                                    BuildContext context,
                                    AsyncSnapshot snapshot,
                                  ) {
                                    var isBookmarked = item.isBookmarked.value;
                                    return Material(
                                      color: isBookmarked
                                          ? const Color(0x30ffffff)
                                          : Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          InkWell(
                                            onLongPress: () {
                                              if (isBookmarked) {
                                                _showMyDialog(() {
                                                  store.bookmarkActionType.add(
                                                    Tuple3(
                                                        QuranBookmarkButtonMode
                                                            .remove,
                                                        item,
                                                        item.quranBookmark),
                                                  );
                                                  Navigator.pop(context);
                                                }, "UnBookmark");
                                              } else {
                                                _showMyDialog(() {
                                                  store.bookmarkActionType.add(
                                                    Tuple3(
                                                        QuranBookmarkButtonMode
                                                            .add,
                                                        item,
                                                        null),
                                                  );
                                                  Navigator.pop(context);
                                                }, "Bookmark");
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                left: 15,
                                                top: 15,
                                                right: 20,
                                                bottom: 25,
                                              ),
                                              child: Stack(
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      !isBlank('aya.bismillah') &&
                                                              aya.index == 1 &&
                                                              item.chapter
                                                                      .chapterNumber !=
                                                                  9 &&
                                                              item.chapter
                                                                      .chapterNumber !=
                                                                  1
                                                          ? Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 6,
                                                                bottom: 10,
                                                              ),
                                                              child:
                                                                  StreamBuilder<
                                                                      double>(
                                                                initialData: store
                                                                    .arabicFontSize$
                                                                    .value,
                                                                stream: store
                                                                    .arabicFontSize$,
                                                                builder: (
                                                                  BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          double>
                                                                      snapshot,
                                                                ) {
                                                                  return Text(
                                                                      Platform.isIOS
                                                                          ? '﷽'
                                                                          : 'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            snapshot.data,
                                                                        fontFamily:
                                                                            'noorehira',
                                                                      ));
                                                                },
                                                              ),
                                                            )
                                                          : Container(),
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                          child:
                                                                              Image(
                                                                        image: const AssetImage(
                                                                            'assets/images/ayah-background.png'),
                                                                        color: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyLarge
                                                                            ?.color,
                                                                        width:
                                                                            44.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      )),
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          '${aya.index}',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                                ruku
                                                                    ? Image(
                                                                        color: Theme.of(context)
                                                                            .iconTheme
                                                                            .color,
                                                                        image: const AssetImage(
                                                                            'assets/images/ruku.png'),
                                                                        width:
                                                                            20.0,
                                                                        height:
                                                                            20.0,
                                                                      )
                                                                    : Container(),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    isBookmarked
                                                                        ? Builder(
                                                                            builder:
                                                                                (
                                                                              BuildContext context,
                                                                            ) {
                                                                              return Animator<double>(
                                                                                duration: const Duration(
                                                                                  milliseconds: 100,
                                                                                ),
                                                                                builder: (context, anim, child) {
                                                                                  return Transform.scale(
                                                                                    scale: anim.value,
                                                                                    child: IconButton(
                                                                                      icon: const Icon(
                                                                                        Icons.bookmark,
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        store.bookmarkActionType.add(
                                                                                          Tuple3(QuranBookmarkButtonMode.remove, item, item.quranBookmark),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                          )
                                                                        : Animator<
                                                                            double>(
                                                                            duration:
                                                                                const Duration(
                                                                              milliseconds: 100,
                                                                            ),
                                                                            builder:
                                                                                (context, anim, child) {
                                                                              return Transform.scale(
                                                                                scale: anim.value,
                                                                                child: IconButton(
                                                                                  icon: const Icon(
                                                                                    Icons.bookmark_border,
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    store.bookmarkActionType.add(
                                                                                      Tuple3(QuranBookmarkButtonMode.add, item, null),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              );
                                                                            },
                                                                          )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox.fromSize(
                                                        size: const Size.fromHeight(
                                                          15,
                                                        ),
                                                      ),
                                                      StreamBuilder<double>(
                                                        initialData: store
                                                            .arabicFontSize$
                                                            .value,
                                                        stream: store
                                                            .arabicFontSize$,
                                                        builder: (
                                                          BuildContext context,
                                                          AsyncSnapshot<double>
                                                              snapshot,
                                                        ) {
                                                          return Text(
                                                            aya.text,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  snapshot.data,
                                                              fontFamily:
                                                                  'noorehira',
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ]..add(
                                                        Builder(
                                                          builder: (
                                                            BuildContext
                                                                context,
                                                          ) {
                                                            return StreamBuilder<
                                                                DataState>(
                                                              initialData: item
                                                                  .translationState
                                                                  .valueOrNull,
                                                              stream: item
                                                                  .translationState
                                                                  .delay(
                                                                const Duration(
                                                                  milliseconds:
                                                                      500,
                                                                ),
                                                              ),
                                                              builder: (
                                                                BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        DataState>
                                                                    snapshot,
                                                              ) {
                                                                return WidgetSelector<DataState>(
                                                                  selectedState:
                                                                      snapshot
                                                                          .data ?? DataState.none,
                                                                  states: {
                                                                    DataState(
                                                                      enumSelector:
                                                                          EnumSelector
                                                                              .loading,
                                                                    ): Center(
                                                                      child: circularProgress(
                                                                          context),
                                                                    ),
                                                                    DataState(
                                                                      enumSelector:
                                                                          EnumSelector
                                                                              .success,
                                                                    ): Builder(
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return StreamBuilder<
                                                                            List<Tuple2<Aya, TranslationData>>>(
                                                                          initialData: item.translations.valueOrNull,
                                                                          stream: item
                                                                              .translations
                                                                              .delay(
                                                                            const Duration(
                                                                              milliseconds: 500,
                                                                            ),
                                                                          ),
                                                                          builder:
                                                                              (
                                                                            BuildContext
                                                                                context,
                                                                            AsyncSnapshot<List<Tuple2<Aya, TranslationData>>>
                                                                                snapshot,
                                                                          ) {
                                                                            List<Widget>
                                                                                listTranslationWidget =
                                                                                [];
                                                                            for (var item
                                                                                in snapshot.data ?? []) {
                                                                              var translation = item.item1;
                                                                              var translationData = item.item2;
                                                                              listTranslationWidget.add(Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                children: <Widget>[
                                                                                  SizedBox.fromSize(
                                                                                    size: const Size.fromHeight(10),
                                                                                  ),
                                                                                  SizedBox.fromSize(
                                                                                    size: const Size.fromHeight(1),
                                                                                  ),
                                                                                  Container(
                                                                                    child: StreamBuilder<double>(
                                                                                      initialData: store.translationFontSize$.value,
                                                                                      stream: store.translationFontSize$,
                                                                                      builder: (
                                                                                        BuildContext context,
                                                                                        AsyncSnapshot<double> snapshot,
                                                                                      ) {
                                                                                        return SelectableText(
                                                                                          translation.text,
                                                                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                                                                fontSize: snapshot.data,
                                                                                                fontFamily: translationData.languageCode == 'kan' ? 'kannada' : null,
                                                                                              ),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ));
                                                                            }
                                                                            return Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: listTranslationWidget,
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                  ),
                                                ],
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
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        _store.selectedChapter$.valueOrNull?.chapterNumber == 114
                            ? InkWell(
                                onTap: () async {
                                  Navigator.pushNamed(context, '/dua',
                                      arguments: {
                                        'fontSize':
                                            _store.arabicFontSize$.value,
                                      });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 6,
                                    bottom: 10,
                                  ),
                                  child: const Text(
                                    'دعاء ختم القرآنِ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'noorehira',
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Platform.isIOS
                            ? iosAudioPlayerView()
                            : AudioPlayerView(),
                      ],
                    );
                  },
                ),
              ),
              DataState(
                enumSelector: EnumSelector.loading,
              ): ScrollablePositionedList.builder(
                itemCount: 10,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return InkWell(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 15,
                        right: 20,
                        bottom: 25,
                      ),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: const <Widget>[
                                        ShimmerLoading(
                                          height: 30,
                                        ),
                                        ShimmerLoading(
                                          height: 24,
                                          width: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const ShimmerLoading(
                                    height: 24,
                                    width: 16,
                                  ),
                                ],
                              ),
                              SizedBox.fromSize(
                                size: const Size.fromHeight(
                                  14,
                                ),
                              ),
                              const ShimmerLoading(
                                height: 28,
                              ),
                            ],
                          ),
                        ],
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

  AudioPlayer audioPlayer = AudioPlayer();
  Duration? currentPosition;
  Duration? totalDuration;

  final StreamController<AppPlayerState> _streamController = StreamController<AppPlayerState>.broadcast();

  void checkInitValue(String url) {
    var duration = PreferencesUtils.getAudioTime(url, 0);
    seekToSecond(duration);
  }

  Timer? _timer;

  Future<int> setMediaURL(String url) async {
    try {
      String url2 = '';
      if (url.isNotEmpty) {
        if (url.contains(",")) {
          url2 = url.substring(url.indexOf(',') + 1, url.length);
          url = url.substring(0, url.indexOf(','));
        }
      }
      await audioPlayer.setSourceUrl(url);
      checkInitValue(url);

      audioPlayer.onDurationChanged.listen((d) {
        totalDuration = d;
        _streamController.add(AppPlayerState.paused(totalDuration: d));
      });

      audioPlayer.onPlayerStateChanged.listen((PlayerState s) async {
        if (currentPosition == null || currentPosition!.inSeconds < 0) {
          currentPosition = const Duration(seconds: 0);
        }
        PreferencesUtils.setAudioTime(url, currentPosition!.inSeconds);
        if (s == PlayerState.playing) {
          _streamController.add(AppPlayerState.playing(
              totalDuration: totalDuration, duration: currentPosition));
        } else if (s == PlayerState.paused) {
          _streamController.add(AppPlayerState.paused(
              totalDuration: totalDuration, duration: currentPosition));
        } else if (s == PlayerState.completed) {
          currentPosition = const Duration(seconds: 0);
          PreferencesUtils.setAudioTime(url, 0);
          _streamController.add(AppPlayerState.paused(
              totalDuration: totalDuration, duration: currentPosition));
          if (url2.isNotEmpty) {
            var value = await setMediaURL(url2);
            if (value == 1) await audioPlayer.resume();
          }
        }
      });
      audioPlayer.onPositionChanged.listen((Duration p) {
        if (p.inSeconds != 0 && (Platform.isAndroid || !playerUsed)) {
          playerUsed = true;
          _streamController.add(AppPlayerState.playing(
              totalDuration: totalDuration, duration: p));
        }
      });
      return 1;
    } catch (ex) {
      return 0;
    }
  }

  bool playerUsed = false;

  void showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0x90000000),
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget AudioPlayerView() {
    return StreamBuilder<AppPlayerState>(
        stream: _streamController.stream,
        initialData: AppPlayerState.initial(),
        builder: (context, snapshot) {
          final playerStateValue = snapshot.data;
          var isSliderReady = playerStateValue != null &&
              playerStateValue.duration != null &&
              playerStateValue.totalDuration != null;

          currentPosition = playerStateValue?.duration;
          return Container(
            color: const Color(0x86000000),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                playerStateValue?.isBuffering != true
                    ? IconButton(
                        icon: Icon(
                          playerStateValue?.isPlaying == true
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: const Color(0xffe1d79f),
                        ),
                        onPressed: () async {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult != ConnectivityResult.none) {
                            _streamController.add(AppPlayerState.buffering(
                                totalDuration: totalDuration,
                                duration: currentPosition));
                            if (playerStateValue?.isPlaying != true) {
                              await audioPlayer.resume();
                            } else {
                              await audioPlayer.pause();
                            }
                          } else {
                            showMessage('No internet connection');
                          }
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: SizedBox(
                          height: 18.0,
                          width: 18.0,
                          child: circularProgress(context),
                        ),
                      ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xffe1d79f),
                      inactiveTrackColor: const Color(0xfff9f7ec),
                      trackShape: const RectangularSliderTrackShape(),
                      trackHeight: 2.0,
                      thumbColor: const Color(0xffb4ac7f),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayColor: const Color(0x60e7dfb2),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 28.0),
                    ),
                    child: Slider(
                        value: (isSliderReady &&
                                (playerStateValue.totalDuration?.inSeconds ?? 0) >
                                    (currentPosition?.inSeconds ?? 0))
                            ? (playerStateValue.duration?.inSeconds.toDouble() ?? 0.0)
                            : 0.0,
                        min: 0.0,
                        max: isSliderReady
                            ? (playerStateValue.totalDuration?.inSeconds
                                .toDouble() ?? 0.0)
                            : 0.0,
                        onChanged: (double value) {
                          seekToSecond(value.toInt());
                        }),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget iosAudioPlayerView() {
    return StreamBuilder<AppPlayerState>(
        stream: _streamController.stream,
        initialData: AppPlayerState.initial(),
        builder: (context, snapshot) {
          final playerStateValue = snapshot.data;
          currentPosition = playerStateValue?.duration;
          return Container(
            color: const Color(0x86000000),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: 55.0,
                    height: 55.0,
                    child: playerStateValue?.isBuffering != true
                        ? IconButton(
                            icon: Icon(
                              playerStateValue?.isPlaying == true
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: const Color(0xffe1d79f),
                            ),
                            onPressed: () async {
                              var connectivityResult =
                                  await (Connectivity().checkConnectivity());
                              if (connectivityResult !=
                                  ConnectivityResult.none) {
                                _streamController.add(AppPlayerState.buffering(
                                    totalDuration: totalDuration,
                                    duration: currentPosition));
                                if (playerStateValue?.isPlaying != true) {
                                  await audioPlayer.resume();
                                } else {
                                  await audioPlayer.pause();
                                }
                              } else {
                                showMessage('No internet connection');
                              }
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: circularProgress(context),
                          ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  Future<void> _showMyDialog(VoidCallback onPress, String buttonText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextButton(
            onPressed: onPress,
            child: Text(buttonText),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _streamController.close();
    audioPlayer.release();
    audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
