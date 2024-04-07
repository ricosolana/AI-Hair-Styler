import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO properly implement
// https://docs.flutter.dev/cookbook/persistence/key-value

const String apiHostPrefKey = 'api-host';
const String apiTokenPrefKey = 'api-token';

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
  bool _isDarkTheme = false;
  String _apiHost = '';
  String _apiToken = '';
  late TextEditingController _apiHostTextEditingController;
  late TextEditingController _apiTokenTextEditingController;
  //late TextEditingController _textEditingController;

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
    getApiServerPref().then((apiHost) {
      setState(() {
        _apiHost = apiHost;
      });
    });
  }

  Future<void> _saveApiServer(String apiHost) async {
    setApiServerPref(apiHost);
    setState(() {
      _apiHost = apiHost;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadApiServer();
    _apiHostTextEditingController = TextEditingController(text: _apiHost);
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
                title: const Text('API Host'),
                leading: const Icon(CupertinoIcons.wrench),
                description: Text(
                  _apiHost,
                ), //const Text('Backend servers to process image'),
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('API Host'),
                        content: TextField(
                          controller: _apiHostTextEditingController,
                          decoration: const InputDecoration(
                            hintText: "http://10.0.2.2/",
                          ), // 10.0.2.2 refers to host when virtualized
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
                              _saveApiServer(
                                  _apiHostTextEditingController.text);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              // TODO create another settings tile type to handle prompted text input
              //  with validation, error messages, and simple submit function

              SettingsTile.navigation(
                title: const Text('API Token'),
                leading: const Icon(CupertinoIcons.wrench),
                description: Text(_apiToken),
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('API Token'),
                        content: TextField(
                          controller: _apiTokenTextEditingController,
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
                              //_saveApiToken(_textEditingController.text);
                              // TODO save token
                              _apiToken = _apiTokenTextEditingController.text;
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
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



class MyTextInputSettingsTile extends StatefulWidget {

  final String title;
  final String prefKey;
  final String defaultText;

  MyTextInputSettingsTile({required this.title, required this.prefKey, this.defaultText=''});

  @override
  _MyTextInputSettingsTileState createState() =>
      _MyTextInputSettingsTileState();
}

class _MyTextInputSettingsTileState extends State<MyTextInputSettingsTile> {
  
  //final _controller = TextEditingController();

  //final String title;
  //final String prefKey;
  String rawText;
  late TextEditingController _textEditingController;
  //_MyTextInputSettingsTileState({required this.title, required this.prefKey, this.rawText=''});

  _MyTextInputSettingsTileState({this.rawText=widget.defaultText});

  void _loadText() {
    setState(() {
      rawText = Provider.of<SharedPreferences>(context).getString(widget.prefKey) ?? rawText;
    });
  }

  void _saveText(String text) {
    setState(() {
      rawText = text;
      Provider.of<SharedPreferences>(context).setString(widget.prefKey, rawText);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadText();
    _textEditingController = TextEditingController(text: rawText);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsTile.navigation(
      title: Text(widget.title),
      leading: const Icon(CupertinoIcons.wrench),
      description: Text(rawText),
      onPressed: (context) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(widget.title),
              content: TextField(
                controller: _textEditingController,
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
                    rawText = _textEditingController.text;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
