import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtils {
  static Future<SharedPreferences>? get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static int getAudioTime(String key, int defValue) {
    if (_prefsInstance != null) {
      return _prefsInstance!.getInt(key) ?? defValue;
    } else
      return 0;
  }

  static Future<bool> setAudioTime(String key, int value) async {
    var prefs = await _instance;
    return prefs?.setInt(key, value) ?? Future.value(false);
  }
}
