import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider with ChangeNotifier {
  final SharedPreferences _prefs;

  // TODO cache set() values in memory until disk persist
  //  will help avoid disk write slows

  PreferencesProvider({required SharedPreferences prefs}) : _prefs = prefs;

  T getOr<T>(String prefKey, T def) {
    final Object? value = _prefs.get(prefKey);
    if (value is T) {
      return value;
    }
    return def;
    //return pref.get(prefKey) as T ?? def;
  }

  T? get<T>(String prefKey) {
    if (T == List<String>) {
      return _prefs.getStringList(prefKey) as T?;
    }
    return _prefs.get(prefKey) as T?;
    //return pref.get(prefKey) as T ?? def;
  }

  T getOrCreate<T>(String prefKey, T def) {
    final Object? value = _prefs.get(prefKey);
    if (value is T) {
      return value;
    } else if (def is List<String> && value is List<Object?>) {
      return _prefs.getStringList(prefKey) as T;
    }
    set(prefKey, def);
    return def;
    //return pref.get(prefKey) as T ?? def;
  }

  Future<bool> set<T>(String prefKey, T value) async {
    bool status;
    if (T == int) {
      status = await _prefs.setInt(prefKey, value as int);
    } else if (T == double) {
      status = await _prefs.setDouble(prefKey, value as double);
    } else if (T == bool) {
      status = await _prefs.setBool(prefKey, value as bool);
    } else if (T == String) {
      status = await _prefs.setString(prefKey, value as String);
    } else if (T == List<String>) {
      status = await _prefs.setStringList(prefKey, value as List<String>);
    } else {
      throw UnsupportedError('Unsupported type $T');
    }
    notifyListeners();
    return status;
  }

  Future<bool> createListOrAdd<T>(String prefKey, List<String> toAdd) async {
    return set(
      prefKey,
      (get<List<String>>(prefKey) ?? <String>[])..addAll(toAdd),
    );
  }

  //Future<bool> createListOrAdd<T>(String prefKey, List<String> toAdd) async {
  //  return set(prefKey, (get<List<String>>(prefKey) ?? <String>[])..addAll(toAdd));
  //}
}
