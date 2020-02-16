import 'package:shared_preferences/shared_preferences.dart';

import 'package:stitch_core/stitch_core.dart' show Storage;

const String stitchPrefixKey = '__stitch.client';

class LocalStorage implements Storage {
  SharedPreferences _prefs;
  final String _suiteName;

  LocalStorage(String suiteName) : _suiteName = suiteName;

  Future<void> loadPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<String> gets(String key) async {
    await loadPrefs(); // make sure preferences are loaded
    return _prefs.getString(getKey(key));
  }

  sets(String key, String value) async {
    await loadPrefs(); // make sure preferences are loaded
    _prefs.setString(this.getKey(key), value);
  }
  
  remove(String key) async {
    _prefs.remove(this.getKey(key));
  }

  String getKey(String forKey) {
    return '$stitchPrefixKey.$_suiteName.$forKey';
  }
}
