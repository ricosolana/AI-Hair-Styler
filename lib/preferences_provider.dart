import 'package:shared_preferences/shared_preferences.dart';

late final Wrapreferences prefs;

class Wrapreferences {
  final SharedPreferences _sharedPrefs;

  Wrapreferences({required SharedPreferences sharedPrefs}) : _sharedPrefs = sharedPrefs {
    prefs = this;
  }

  T getOr<T>(String prefKey, T def) {
    final Object? value = _sharedPrefs.get(prefKey);
    if (value is T) {
      return value;
    }
    return def;
    //return pref.get(prefKey) as T ?? def;
  }

  T? get<T>(String prefKey) {
    if (T == List<String>) {
      return _sharedPrefs.getStringList(prefKey) as T?;
    }
    return _sharedPrefs.get(prefKey) as T?;
    //return pref.get(prefKey) as T ?? def;
  }

  T ensure<T>(String prefKey) {
    return get<T>(prefKey)!;
  }

  T getOrCreate<T>(String prefKey, T def) {
    final Object? value = _sharedPrefs.get(prefKey);
    if (value is T) {
      return value;
    } else if (def is List<String> && value is List<Object?>) {
      return _sharedPrefs.getStringList(prefKey) as T;
    }
    set(prefKey, def);
    return def;
    //return pref.get(prefKey) as T ?? def;
  }

  Future<bool> set<T>(String prefKey, T value) async {
    bool status;
    if (T == int) {
      status = await _sharedPrefs.setInt(prefKey, value as int);
    } else if (T == double) {
      status = await _sharedPrefs.setDouble(prefKey, value as double);
    } else if (T == bool) {
      status = await _sharedPrefs.setBool(prefKey, value as bool);
    } else if (T == String) {
      status = await _sharedPrefs.setString(prefKey, value as String);
    } else if (T == List<String>) {
      status = await _sharedPrefs.setStringList(prefKey, value as List<String>);
    } else {
      throw UnsupportedError('Unsupported type $T');
    }
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
