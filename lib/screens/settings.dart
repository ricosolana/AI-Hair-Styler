import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';
import 'package:senior_project_hair_ai/screens/settings_text_tile.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO properly implement
// https://docs.flutter.dev/cookbook/persistence/key-value

const String apiHostPrefKey = 'api-host';
const String apiTokenPrefKey = 'api-token';

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({super.key});

  @override
  State<MySettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
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
              createTextSettingsTile(
                  title: const Text('API Host'),
                  leading: const Icon(Icons.cloud_queue),
                  prefKey: apiHostPrefKey,
                  context: context,
                  valueAsDescription: true,
                  validator: (str) {
                    return (Uri.tryParse(str ?? '')?.hasAbsolutePath ?? false)
                        ? null
                        : 'Enter a valid URL; ie: https://10.0.2.2/';
                  },
                  extraActions: <TextButton>[
                    TextButton(
                      child: const Text('Test'),
                      onPressed: () {
                        // try connecting
                        apiRootPath(Provider.of<PreferencesProvider>(context,
                                    listen: false)
                                .get(apiHostPrefKey)!)
                            .then((value) {
                          Fluttertoast.showToast(
                              msg: value != null
                                  ? 'Online'
                                  : 'Unable to reach server');
                        });
                      },
                    ),
                  ]),
              createTextSettingsTile(
                title: const Text('API Token'),
                leading: const Icon(Icons.token),
                prefKey: apiTokenPrefKey,
                context: context,
                valueAsDescription: true,
                //extraActions: TextButton(
                //  automatically retrieve from localhost
                //  child: const Text('Auto'),
                //  onPressed: onPressed,
                //)
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
            ],
          ),
          SettingsSection(
            title: const Text('Customization'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Use Dark Theme'),
                leading: const Icon(Icons.dark_mode),
                initialValue: Provider.of<PreferencesProvider>(context)
                    .getOr(darkThemePrefKey, false),
                onToggle: (isDarkTheme) {
                  Provider.of<PreferencesProvider>(context, listen: false)
                      .set(darkThemePrefKey, isDarkTheme);
                },
              ),
            ], //tiles
          ),
        ],
      ),
    );
  }
}
