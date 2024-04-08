import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';
import 'package:senior_project_hair_ai/screens/settings_text_tile.dart';
import 'package:settings_ui/settings_ui.dart';

// TODO properly implement
// https://docs.flutter.dev/cookbook/persistence/key-value

const String apiHostPrefKey = 'api-host';
const String apiTokenPrefKey = 'api-token';
const String apiDemoPrefKey = 'api-demo';

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
                    child: const Text('Probe'),
                    onPressed: () {
                      // try connecting
                      apiRootPath(
                        Provider.of<PreferencesProvider>(
                          context,
                          listen: false,
                        ).get(apiHostPrefKey)!,
                      ).then((value) {
                        if (value.statusCode == 200) {
                          final map =
                              jsonDecode(value.body) as Map<String, dynamic>;
                          if ((map['name'] as String) ==
                              'ai hair styler generator api') {
                            Fluttertoast.showToast(msg: 'Server is online');
                            return;
                          }
                        }
                        Fluttertoast.showToast(msg: 'Failed to verify server');
                      }).onError((error, stackTrace) {
                        Fluttertoast.showToast(msg: 'Failed to reach server');
                      });
                    },
                  ),
                ],
              ),
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
              SettingsTile.switchTile(
                title: const Text('Demo'),
                description: const Text('API responds with a fast dummy image'),
                leading: const Icon(Icons.dark_mode),
                initialValue: Provider.of<PreferencesProvider>(context)
                    .getOr(apiDemoPrefKey, false),
                onToggle: (value) {
                  Provider.of<PreferencesProvider>(context, listen: false)
                      .set(apiDemoPrefKey, value);
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
