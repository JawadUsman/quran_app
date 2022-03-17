// @dart=2.11
import 'dart:async';
import 'dart:io';

//import 'package:just_audio/just_audio.dart';
// import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:animator/animator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  QuranWidget({Key key}) : super(key: key);

  _QuranWidgetState createState() => _QuranWidgetState();
}

class _QuranWidgetState extends State<QuranWidget>
    with
        BaseStateMixin<QuranStore, QuranWidget>,
        AutomaticKeepAliveClientMixin {
  QuranStore _store;

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
        return r;
      });
      _store.registerDispose(() {
        d.dispose();
      });
    }
  }

  Widget circularProgress(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(cardColor: Color(0xffe1d79f)),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          backgroundColor: Color(0x86000000),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () async {
            store.pickQuranNavigator.executeIf();
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                StreamBuilder<Chapters>(
                  initialData: store.selectedChapter$.value,
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
                Icon(
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
                icon: Icon(Icons.settings),
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        // Defer the drawer until drawer opened
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
            setMediaURL(_store.selectedChapter$.value.audioURL);
          }
          return WidgetSelector<DataState>(
            selectedState: snapshot.data,
            states: {
              DataState(
                enumSelector: EnumSelector.success,
              ): Container(
                child: Observer(
                  builder: (BuildContext context) {
                    var itemIndex = store.listAya.indexWhere(
                      (t) => t.aya.value == store.initialSelectedAya$.value,
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
                                // var ruku = false;
                                var ruku = aya.ruku == 1;
                                //assets/images/
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
                                          ? Color(0x30ffffff)
                                          : Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          InkWell(
                                            onLongPress: () {
                                              if (isBookmarked)
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
                                              else
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
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
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
                                                      // Bismillah
                                                      !isBlank('aya.bismillah') &&
                                                              aya.index == 1 &&
                                                              item.chapter
                                                                      .chapterNumber !=
                                                                  9 &&
                                                              item.chapter
                                                                      .chapterNumber !=
                                                                  1
                                                          //!isBlank('')
                                                          ? Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 6,
                                                                bottom: 10,
                                                              ),
                                                              child: Text(
                                                                'بِسۡـــــــــمِ ٱللهِ ٱلرَّحۡـمَـٰنِ ٱلرَّحِـــــــيمِ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontFamily:
                                                                      'noorehira',
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                      // 1
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                //index
                                                                Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                          child:
                                                                              Image(
                                                                        image: AssetImage(
                                                                            'assets/images/ayah-background.png'),
                                                                        color: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyText1
                                                                            .color,
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
                                                                              TextStyle(
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
                                                                        image: AssetImage(
                                                                            'assets/images/ruku.png'),
                                                                        width:
                                                                            20.0,
                                                                        height:
                                                                            20.0,
                                                                      )
                                                                    : Container(),
                                                                //bookmark
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
                                                                                builder: (v) {
                                                                                  return Transform.scale(
                                                                                    scale: v.value,
                                                                                    child: IconButton(
                                                                                      icon: Icon(
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
                                                                                (v) {
                                                                              return Transform.scale(
                                                                                scale: v.value,
                                                                                child: IconButton(
                                                                                  icon: Icon(
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
                                                        size: Size.fromHeight(
                                                          15,
                                                        ),
                                                      ),
                                                      // 2
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
                                                          //۩ ۞ noorehira
                                                          return Text(
                                                            '${aya.text}',
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  snapshot.data,
                                                              fontFamily:
                                                                  'noorehira',
                                                              // 'qalam Majeed',
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
                                                                  .value,
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
                                                                return WidgetSelector(
                                                                  selectedState:
                                                                      snapshot
                                                                          .data,
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
                                                                          initialData: item.translations.hasValue
                                                                              ? item.translations.value
                                                                              : null,
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
                                                                                in snapshot.data) {
                                                                              var translation = item.item1;
                                                                              var translationData = item.item2;
                                                                              //print('Jawad ${translationData.languageCode}');
                                                                              listTranslationWidget.add(Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                children: <Widget>[
                                                                                  SizedBox.fromSize(
                                                                                    size: Size.fromHeight(10),
                                                                                  ),
                                                                                  /*Container(
                                                                                  child:
                                                                                      Text(
                                                                                    '${translationData.languageCode ?? ''}',
                                                                                    style:
                                                                                        TextStyle(
                                                                                      fontWeight:
                                                                                          FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                ),*/
                                                                                  SizedBox.fromSize(
                                                                                    size: Size.fromHeight(1),
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
                                                                                          '${translation.text}',
                                                                                          style: Theme.of(context).textTheme.bodyText1.copyWith(
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
                                          Container(
                                            height: 1,
                                            color:
                                                Theme.of(context).dividerColor,
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
                      padding: EdgeInsets.only(
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
                              // 1
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
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
                                  ShimmerLoading(
                                    height: 24,
                                    width: 16,
                                  ),
                                ],
                              ),
                              SizedBox.fromSize(
                                size: Size.fromHeight(
                                  14,
                                ),
                              ),
                              // 2
                              ShimmerLoading(
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

  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  Duration currentPosition;
  Duration totalDuration;

  void _audioPlayerStateUpdate(PlayerState state) => state;

  final StreamController<AppPlayerState> _streamController =
      StreamController<AppPlayerState>.broadcast();

  void checkInitValue(String url) {
    var duration = PreferencesUtils.getAudioTime(url, 0);
    if (duration != null) seekToSecond(duration);
  }

  Timer _timer;

  Future<int> setMediaURL(String url) async {
    try {
      //currentPosition = Duration(seconds: 0);
      //_streamController.add(PlayerState.paused(duration: currentPosition));
      //if (audioPlayer != null) await audioPlayer.release();
      String url2;
      if (url.isNotEmpty) {
        if (url.contains(",")) {
          url2 = url.substring(url.indexOf(',') + 1, url.length);
          url = url.substring(0, url.indexOf(','));
        }
      }
      // prepare the player with this audio but do not start playing
      int result = await audioPlayer.setUrl(url);
      print('jawad test result: $result');
      if (result == 1) {
        checkInitValue(url);
        /*if (Platform.isIOS) {
          /*audioPlayer.monitorNotificationStateChanges(_audioPlayerStateUpdate);
          int duration = await audioPlayer.getDuration();
          totalDuration = Duration(milliseconds: duration);
          _streamController.add(AppPlayerState.paused(
              totalDuration: Duration(milliseconds: duration)));*/
          print('Jawad test Timer start');
          /*_timer = new Timer(const Duration(milliseconds: 100), () {
            print('Jawad test Timer end');
            setState(() {
              print('Jawad test set onDurationChanged');
              audioPlayer.onDurationChanged.listen((d) {
                totalDuration = d;
                print('Jawad test set totalDuration $totalDuration');
                _streamController.add(AppPlayerState.paused(totalDuration: d));
              });
            });
          });
          Future.delayed(Duration(milliseconds: 500), () {
            print('Jawad test set onDurationChanged');

            audioPlayer.onDurationChanged.listen((d) {
              totalDuration = d;
              print('Jawad test set totalDuration $totalDuration');
              _streamController.add(AppPlayerState.paused(totalDuration: d));
            });
          });*/
          /*Audio.loadFromRemoteUrl(url, onDuration: ((double seconds) {
            totalDuration = Duration(seconds: seconds.toInt());
            print('Jawad test set totalDuration $totalDuration');
          }));*/
        } else {
          audioPlayer.onDurationChanged.listen((d) {
            totalDuration = d;
            _streamController.add(AppPlayerState.paused(totalDuration: d));
          });
        }*/
        print('Jawad test before onDurationChanged');
        audioPlayer.onDurationChanged.listen((d) {
          print('Jawad test after onDurationChanged: $d');
          totalDuration = d;
          _streamController.add(AppPlayerState.paused(totalDuration: d));
        });

        audioPlayer.onAudioPositionChanged.listen((Duration p) {
          if (p.inSeconds != 0)
            _streamController.add(AppPlayerState.playing(
                totalDuration: totalDuration, duration: p));
        });
        audioPlayer.onPlayerStateChanged.listen((PlayerState s) async {
          if (currentPosition == null || currentPosition.inSeconds < 0)
            currentPosition = Duration(seconds: 0);
          PreferencesUtils.setAudioTime(url, currentPosition.inSeconds);
          if (s == PlayerState.PLAYING) {
            _streamController.add(AppPlayerState.playing(
                totalDuration: totalDuration, duration: currentPosition));
          } else if (s == PlayerState.PAUSED) {
            _streamController.add(AppPlayerState.paused(
                totalDuration: totalDuration, duration: currentPosition));
          } else if (s == PlayerState.COMPLETED) {
            currentPosition = Duration(seconds: 0);
            PreferencesUtils.setAudioTime(url, 0);
            _streamController.add(AppPlayerState.paused(
                totalDuration: totalDuration, duration: currentPosition));
            if (url2 != null && url2.isNotEmpty) {
              var value = await setMediaURL(url2);
              if (value == 1) audioPlayer.resume();
            }
          }
        });
      }
      audioPlayer.onPlayerError.listen((event) {
        totalDuration = Duration(seconds: 0);
        currentPosition = Duration(seconds: 0);
        _streamController.add(AppPlayerState.stopped());
        //showMessage('Unable play the audio, please try again');
      });
      return result;
    } catch (ex) {
      //print('Jawad test ${ex}');
      return 0;
    }
  }

  void showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0x90000000),
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
          //print("Jawad ---> playerStateValue ${playerStateValue.isPlaying}");
          currentPosition = playerStateValue.duration;
          return Container(
            color: Color(0x86000000),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                !playerStateValue.isBuffering
                    ? IconButton(
                        icon: Icon(
                          playerStateValue.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Color(0xffe1d79f),
                        ),
                        onPressed: () async {
                          print("Jawad ---> Button onPressed");
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          print(
                              "Jawad ---> network status $connectivityResult");
                          if (connectivityResult != ConnectivityResult.none) {
                            _streamController.add(AppPlayerState.buffering(
                                totalDuration: totalDuration,
                                duration: currentPosition));
                            if (!playerStateValue.isPlaying) {
                              print("Jawad ---> player resume");
                              await audioPlayer.resume();
                            } else {
                              print("Jawad ---> player pause");
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
                      activeTrackColor: Color(0xffe1d79f),
                      inactiveTrackColor: Color(0xfff9f7ec),
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 2.0,
                      thumbColor: Color(0xffb4ac7f),
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayColor: Color(0x60e7dfb2),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                    ),
                    child: Slider(
                        value: (isSliderReady &&
                                playerStateValue.totalDuration.inSeconds >
                                    currentPosition.inSeconds)
                            ? playerStateValue.duration.inSeconds.toDouble()
                            : 0.0,
                        min: 0.0,
                        max: isSliderReady
                            ? playerStateValue.totalDuration.inSeconds
                                .toDouble()
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
          var isSliderReady = playerStateValue != null &&
              playerStateValue.duration != null &&
              playerStateValue.totalDuration != null;
          currentPosition = playerStateValue.duration;
          return Container(
            color: Color(0x86000000),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: 55.0,
                  height: 55.0,
                  child: !playerStateValue.isBuffering
                      ? IconButton(
                          icon: Icon(
                            playerStateValue.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Color(0xffe1d79f),
                          ),
                          onPressed: () async {
                            print("Jawad ---> Button onPressed");
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());
                            print(
                                "Jawad ---> network status $connectivityResult");
                            if (connectivityResult != ConnectivityResult.none) {
                              _streamController.add(AppPlayerState.buffering(
                                  totalDuration: totalDuration,
                                  duration: currentPosition));
                              if (!playerStateValue.isPlaying) {
                                print("Jawad ---> player resume");
                                await audioPlayer.resume();
                              } else {
                                print("Jawad ---> player pause");
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
          );
        });
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  Future<void> _showMyDialog(Function onPress, String buttonText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: FlatButton(
            child: Text(buttonText),
            onPressed: onPress,
          ),
        );
      },
    );
  }

  //not used
  void playAudio({String url, String key}) async {
    var fetchedFile =
        DefaultCacheManager().getFileStream(url, withProgress: true, key: key);
    fetchedFile.listen((event) {
      if (event is DownloadProgress) {
        var data = event;
        double progress = data.progress * 100;
      } else if (event is FileInfo) {
        var data2 = event;
        print('Jawad test FileInfo: ${data2.file.toString()}');
        playMedia(data2.file.path);
      } else if (event is CacheManager) {
        var cacheManager = event as CacheManager;
        print('Jawad test CacheManager: $cacheManager');
        DefaultCacheManager().removeFile(key);
      } else {
        print('Jawad test else: ${event.runtimeType}');
      }
    });
  }

  //not used
  Future<int> playMedia(String filePath) async {
    try {
      currentPosition = Duration(seconds: 0);
      _streamController.add(AppPlayerState.paused(duration: currentPosition));
      // prepare the player with this audio but do not start playing
      int result = await audioPlayer.play(filePath, isLocal: true);
      print('Jawad test $result');
      if (result == 1) {
        /*if (Platform.isIOS) {
          audioPlayer.monitorNotificationStateChanges(_audioPlayerStateUpdate);
          int duration = await audioPlayer.getDuration();
          totalDuration = Duration(milliseconds: duration);
          _streamController.add(AppPlayerState.paused(
              totalDuration: Duration(milliseconds: duration)));
        } else {
          audioPlayer.onDurationChanged.listen((d) {
            totalDuration = d;
            _streamController.add(AppPlayerState.paused(totalDuration: d));
          });
        }*/
        print('Jawad test before onDurationChanged');
        audioPlayer.onDurationChanged.listen((d) {
          print('Jawad test after onDurationChanged $d');
          totalDuration = d;
          _streamController.add(AppPlayerState.paused(totalDuration: d));
        });
        audioPlayer.onPlayerStateChanged.listen((PlayerState s) async {
          if (currentPosition == null || currentPosition.inSeconds < 0)
            currentPosition = Duration(seconds: 0);
          print("Jawad player status: $s ");
          if (s == PlayerState.PLAYING) {
            _streamController.add(AppPlayerState.playing(
                totalDuration: totalDuration, duration: currentPosition));
          } else if (s == PlayerState.PAUSED) {
            _streamController.add(AppPlayerState.paused(
                totalDuration: totalDuration, duration: currentPosition));
          } else if (s == PlayerState.COMPLETED) {
            currentPosition = Duration(seconds: 0);
            _streamController.add(AppPlayerState.paused(
                totalDuration: totalDuration, duration: currentPosition));
          }
        });
        audioPlayer.onAudioPositionChanged.listen((Duration p) {
          _streamController.add(AppPlayerState.playing(
              totalDuration: totalDuration, duration: p));
        });
      }
      audioPlayer.onPlayerError.listen((event) {
        print('Jawad audioPlayer error : $event');
        totalDuration = Duration(seconds: 0);
        currentPosition = Duration(seconds: 0);
        _streamController.add(AppPlayerState.stopped());
        showMessage('Unable play the audio, please try again');
      });
      return result;
    } catch (ex) {
      //print('Jawad test ${ex}');
      return 0;
    }
  }

  @override
  void dispose() {
    if (_streamController != null) _streamController.close();
    if (audioPlayer != null) {
      audioPlayer.release();
      audioPlayer.dispose();
    }
    super.dispose();
    if (_timer != null) _timer.cancel();
  }
}
