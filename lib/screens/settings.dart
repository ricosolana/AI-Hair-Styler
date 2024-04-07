import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
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
  return getPref(apiHostPrefKey, '');
}

Future<void> setApiServerPref(String apiServer) async {
  setPref(apiHostPrefKey, apiServer);
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

              //SettingsTile.navigation(
              //  title: const Text('API Token2'),
              //  leading: const Icon(CupertinoIcons.wrench),
              //  description: Text(_apiToken),
              //  onPressed: (context) {
              //    navigateTo(
              //        context: context,
              //        screen: const MyTextDialog(
              //          title: 'API Token2',
              //          prefKey: 'api-token-2-example',
              //        ),
              //        style: NavigationRouteStyle.material);
              //  },
              //),

              /*
              SettingsTile.navigation(
                title: const Text('API Token2'),
                leading: const Icon(CupertinoIcons.wrench),
                description: Text(_apiToken),
                onPressed: (context) {
                  navigateTo(
                    context: context, 
                    screen: const MyTextDialog(
                      title: 'API Token2', 
                      prefKey: 'api-token-2-example',
                    ), 
                    style: NavigationRouteStyle.material
                  );
                },
              ),*/

              createTextSettingsTile(
                title: const Text('API Token2'), 
                prefKey: 'api-token-2-example',
                context: context,
                valueAsDescription: true
              ),

              createTextSettingsTile(
                title: const Text('api url2'), 
                prefKey: 'api-url2-example',
                context: context,
                valueAsDescription: true,
                validator: (str) {
                  return (Uri.tryParse(str ?? '')?.hasAbsolutePath ?? false) ? null : 'Must enter a URL';
                }
              )
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





class MyTextDialog extends StatefulWidget {
  //final String title;
  final Text title;
  final String prefKey;
  final String defaultText;
  final String? Function(String?)?
      validator; // Add a validator function parameter

  const MyTextDialog({
    required this.title,
    required this.prefKey,
    this.defaultText = '',
    this.validator, // Initialize the validator function
  });

  @override
  _MyTextDialogState createState() => _MyTextDialogState();
}

class _MyTextDialogState extends State<MyTextDialog> {
  late String textString;
  late TextEditingController _textEditingController;

  final _formKey = GlobalKey<FormState>();

  void _loadText() {
    setState(() {
      textString = Provider.of<PreferencesProvider>(context, listen: false)
              .getOr<String>(widget.prefKey, widget.defaultText);
    });
  }

  void _saveText(String text) {
    setState(() {
      textString = text;
      Provider.of<PreferencesProvider>(context, listen: false)
          .set(widget.prefKey, textString);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadText();
    _textEditingController = TextEditingController(text: textString);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title, //Text(widget.title),
      // TODO test if form doesnt look tacky
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textEditingController,
          validator: widget.validator, // Apply the validator function
        ),
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
            //if (_textEditingController.text.isNotEmpty) {
            if (_formKey.currentState!.validate()) {
              _saveText(_textEditingController.text);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );

    /*
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
              // TODO test if form doesnt look tacky
              content: Form(
                child: TextFormField(
                  controller: _textEditingController,
                  validator: widget.validator, // Apply the validator function
                ),
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
                    if (_textEditingController.text.isNotEmpty) {
                      _saveText(_textEditingController.text);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );*/
  }
}

SettingsTile createTextSettingsTile(
    {
    required BuildContext context,
    // SettingsTile.navigation ctor:
    Widget? leading,
    Widget? trailing,
    Widget? value,
    required Text title,
    Widget? description,
    bool enabled = true,
    Key? key,
    // dialog ctor:
    required String prefKey,
    String defaultText = '',
    bool valueAsDescription = false,
    String? Function(String?)? validator}) {
  
      return SettingsTile.navigation(
        leading: leading,
        trailing: trailing,
        value: value,
        title: title,
        //description: description,
        description: valueAsDescription ? 
          Consumer<PreferencesProvider>(
            builder: (context, preferencesProvider, child) {
              return Text(preferencesProvider.getOr(prefKey, defaultText));
            }
          ) : description,
        enabled: enabled,
        key: key,
        onPressed: (context) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyTextDialog(
                title: title,
                prefKey: prefKey,
                defaultText: defaultText,
                validator: validator,
              );
            },
          );
        },
      );
}

/*
class MyTextTile extends SettingsTile {
 final String title;
 final String prefKey;
 final String defaultText;
 final String? Function(String?)? validator;

 MyTextTile({
    required this.title,
    required this.prefKey,
    this.defaultText = '',
    this.validator,
 });

 @override
 Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyTextDialog(
              title: title,
              prefKey: prefKey,
              defaultText: defaultText,
              validator: validator,
              onDialogDismissed: (String newText) {
                // Handle the new text here, e.g., update the tile's state
              },
            );
          },
        );
      },
    );
 }
}*/

//const MyTextDialog({
//  required this.title,
//  required this.prefKey,
//  this.defaultText = '',
//  this.validator, // Initialize the validator function
//});
//auto
/*
SettingsTile createTextSettingsTile({ 
  // SettingsTile.navigation ctor:
 Widget? leading,
 Widget? trailing,
 Widget? value,
 required Text title,
 Widget? description,
 bool enabled = true,
 Key? key,
  // dialog ctor:
  required String prefKey,
  String defaultText = '',
  String? Function(String?)? validator
}) {
  String rawText;

  void loadText() {
    // FIX THIS
    setState(() {
      rawText =
          Provider.of<SharedPreferences>(context, listen: false).getString(widget.prefKey) ??
              widget.defaultText;
    });
  }

  void saveText(String text) {
    // FIX THIS
    setState(() {
      rawText = text;
      Provider.of<SharedPreferences>(context)
          .setString(widget.prefKey, rawText);
    });
  }

  loadText();

  final controller =  TextEditingController(text: rawText);

 return SettingsTile.navigation(
    leading: leading,
    trailing: trailing,
    value: value,
    title: title,
    description: description,
    enabled: enabled,
    key: key,
    onPressed: (context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title,
            // TODO test if form doesnt look tacky
            content: Form(
              child: TextFormField(
                // FIX where _textEditingController should be stored
                controller: controller,
                validator: validator, // Apply the validator function
              ),
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
                  if (controller.text.isNotEmpty) {
                    saveText(controller.text);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    },
 );
}
*/

/*
// my partially-broken one
SettingsTile createTextSettingsTile(
  // SettingsTile.navigation ctor:
  String title, {
    Widget? leading,
    Widget? trailing,
    Widget? value,
    Widget? description,
    bool enabled = true,
    Key? key,
  }) {
    return SettingsTile.navigation(
      title: title,
      // ...

    );
  }
*/
