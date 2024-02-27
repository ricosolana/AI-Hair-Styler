import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO properly implement
// https://docs.flutter.dev/cookbook/persistence/key-value

Future<T> getPref<T>(String prefKey, T def) async {
  final pref = await SharedPreferences.getInstance();
  return pref.get(prefKey) as T ?? def;
}

Future<bool> setPref<T>(String prefKey, T value) async {
  final pref = await SharedPreferences.getInstance();
  if (T == int) {
    return pref.setInt(prefKey, value as int);
  } else if (T == double) {
    return pref.setDouble(prefKey, value as double);
  } else if (T == bool) {
    return pref.setBool(prefKey, value as bool);
  } else if (T == String) {
    return pref.setString(prefKey, value as String);
  } else if (T == List<String>) {
    return pref.setStringList(prefKey, value as List<String>);
  } else {
    throw UnsupportedError('Unsupported type $T');
  }
}

Future<bool> getThemePref() async {
  return getPref(darkThemePrefKey, false);
}

Future<void> setThemePref(bool isDarkTheme) async {
  setPref(darkThemePrefKey, isDarkTheme);
}

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({super.key});

  @override
  State<MySettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  late CameraDescription camera;

  bool _isDarkTheme = false;

  Future<void> _loadTheme() async {
    getThemePref().then((isDarkTheme) {
      setState(() {
        _isDarkTheme = isDarkTheme;
      });
    });
  }

  Future<void> _saveTheme(bool isDarkTheme) async {
    setThemePref(isDarkTheme);
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    themeNotifier.themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
    setState(() {
      _isDarkTheme = isDarkTheme;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('General:'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('My Abstract'),
                leading: const Icon(CupertinoIcons.wrench),
                description: const Text('Some text'),
                onPressed: (context) {
                  //Navigation.navigateTo(context: context, screen: screen, style: style)
                },
              ),
              //SettingsTile.switchTile(
              //  title: ,
              //)
            ],
          ),
          SettingsSection(
            title: const Text('Options:'),
            tiles: [
              SettingsTile(
                title: const Text('Option 1'),
                leading: const Icon(Icons.screen_lock_landscape),
              ),
              SettingsTile(
                title: const Text('Option 2'),
                leading: const Icon(Icons.screen_lock_landscape),
              ),
              //SettingsTile.switchTile(
              //  title: ,
              //)
            ],
          ),
          SettingsSection(
            title: const Text('Customization:'),
            tiles: [
              //SettingsTile(
              //  title: const Text('Change Theme and Colors'),
              //  leading: const Icon(Icons.palette_rounded),
              //  onPressed: (context) {
              //    navigateTo(
              //      context: context,
              //      screen: ColorsPage(),
              //      style: NavigationRouteStyle.material,
              //    );
              //  },
              //),
              SettingsTile.switchTile(
                title: const Text('Use Dark Theme'),
                leading: const Icon(Icons.dark_mode),
                initialValue:
                    _isDarkTheme, // TODO ensure this reflects saved setting
                onToggle: _saveTheme,
              ),
            ], //tiles
          ),
        ],
      ),
    );
  }
}
