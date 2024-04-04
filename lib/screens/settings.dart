import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/navigation.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO properly implement
// https://docs.flutter.dev/cookbook/persistence/key-value

const String apiServerPrefKey = 'api-server';

Future<T> getPref<T>(String prefKey, T def) async {
  final pref = await SharedPreferences.getInstance();
  final Object? value = pref.get(prefKey);
  if (value is T) {
    return value;
  }
  return def;
  //return pref.get(prefKey) as T ?? def;
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

Future<String> getApiServerPref() async {
  return getPref(apiServerPrefKey, '');
}

Future<void> setApiServerPref(String apiServer) async {
  setPref(apiServerPrefKey, apiServer);
}

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({super.key});

  @override
  State<MySettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  late CameraDescription camera;

  bool _isDarkTheme = false;
  String _apiServer = "";
  late TextEditingController _textEditingController; // = TextEditingController(text:);

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

  Future<void> _loadApiServer() async {
    getApiServerPref().then((apiServer) {
      setState(() {
        _apiServer = apiServer;
      });
    });
  }

  Future<void> _saveApiServer(String apiServer) async {
    setApiServerPref(apiServer);
    setState(() {
      _apiServer = apiServer;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadApiServer();
    _textEditingController = TextEditingController(text: _apiServer);
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
            title: const Text('General'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('API Server'),
                leading: const Icon(CupertinoIcons.wrench),
                description: Text(_apiServer), //const Text('Backend servers to process image'),
                onPressed: (context) {


                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('API Server'),
                        content: TextField(
                          controller: _textEditingController,
                          decoration: const InputDecoration(hintText: "https://10.10.10.1/"),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Save'),
                            onPressed: () {
                              // Handle the submit action
                              _saveApiServer(_textEditingController.text);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );


                },
              ),
              //SettingsTile.switchTile(
              //  title: ,
              //)
            ],
          ),
          SettingsSection(
            title: const Text('Options'),
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
            title: const Text('Customization'),
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
