import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/pages/quran_settings_app/quran_settings_app_store.dart';
import 'package:rxdart/rxdart.dart';

class QuranSettingsAppWidget extends StatefulWidget {
  final QuranSettingsAppStore store;
  const QuranSettingsAppWidget({
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  _QuranSettingsFontSApptState createState() => _QuranSettingsFontSApptState();
}

class _QuranSettingsFontSApptState extends State<QuranSettingsAppWidget>
    with BaseStateMixin<QuranSettingsAppStore, QuranSettingsAppWidget> {
  @override
  QuranSettingsAppStore get store => widget.store;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: <Widget>[
          ExpandableNotifier(
            initialExpanded: false,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  ExpandablePanel(
                    theme: ExpandableThemeData(
                      iconColor: Theme.of(context).colorScheme.secondary,
                    ),
                    header: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        store.localization.getByKey(
                          'quran_settings_app_widget.title',
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    collapsed: Container(),
                    expanded: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          StreamBuilder<List<LanguageModel>>(
                            initialData: const [],
                            stream: store.supportedLanguages,
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<List<LanguageModel>> snapshot,
                            ) {
                              var items = snapshot.data ?? [];

                              return StreamBuilder<LanguageModel>(
                                initialData: null,
                                stream:
                                    store.initialiSelectedLanguage.mergeWith([
                                  store.selectedLanguage,
                                ]),
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<LanguageModel> snapshot,
                                ) {
                                  var initialValue = snapshot.data;
                                  if (initialValue == null) {
                                    return Container();
                                  }

                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton<LanguageModel>(
                                      onChanged: (v) {
                                        if (v != null) {
                                          store.selectedLanguage.add(v);
                                        }
                                      },
                                      value: initialValue,
                                      isExpanded: true,
                                      isDense: true,
                                      items: items.map((f) {
                                        return DropdownMenuItem<LanguageModel>(
                                          value: f,
                                          child: Text(
                                            f.name,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: 5,
                            child: Center(
                              child: Container(
                                height: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          Text(
                            store.localization.getByKey(
                              'quran_settings_app_widget.language',
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
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
  }
}
