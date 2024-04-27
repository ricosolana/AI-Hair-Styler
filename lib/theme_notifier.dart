import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';

class ThemeNotifier extends ChangeNotifier {
  late ThemeMode _themeMode;
  // TODO system dark
  ThemeNotifier() {
    final oldThemeDark = prefs.get<bool>(oldDarkThemePrefKey);
    if (oldThemeDark != null) {
      // create new / reparse
      theme = oldThemeDark ? ThemeMode.dark : ThemeMode.light;
      prefs.sharedPrefs.remove(oldDarkThemePrefKey);
    } else {
      _themeMode = ThemeMode.values.byName(prefs.getOrCreate(themeModePrefKey, 'system'));
    }
  }

  ThemeMode get theme => _themeMode;
  set theme(ThemeMode themeMode) {
    _themeMode = themeMode;
    prefs.set(themeModePrefKey, themeMode.name);
    notifyListeners();
  }
}