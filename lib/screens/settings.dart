import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/listenable.dart';
import 'package:senior_project_hair_ai/notifications.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';
import 'package:senior_project_hair_ai/screens/settings_text_tile.dart';
import 'package:settings_ui/settings_ui.dart';

// TODO properly implement
// https://docs.flutter.dev/cookbook/persistence/key-value

const String apiHostPrefKey = 'api-host';
const String apiTokenPrefKey = 'api-token';
const String apiDemoPrefKey = 'api-demo';
const String apiCachedTemplateListPrefKey = 'api-cached-template-list';

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
      // TODO how to update without passing _notifier along to every param
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('API Settings'),
            tiles: [
              // HOST INPUT
              createTextSettingsTile(
                title: const Text('API Host'),
                leading: const Icon(Icons.cloud_queue),
                prefKey: apiHostPrefKey,
                context: context,
                valueAsDescription: true,
                validator: (str) {
                  if (str == null || str.isEmpty) {
                    return 'Must not be empty';
                  } else {
                    return (Uri
                        .tryParse(str.endsWith('/') ? str : '$str/')
                        ?.hasAbsolutePath ??
                        false)
                        ? null
                        : 'Enter a valid URL; ie: https://10.0.2.2/';
                  }
                },
                onSave: (str) {
                  setState(() {});
                  bapiApiTemplatesList(str).then((response) {
                    if (response.statusCode == 200) {
                      final list = List<String>.from(
                        jsonDecode(response.body) as List<dynamic>,
                      );
                      prefs.set(apiCachedTemplateListPrefKey, list);
                      Fluttertoast.showToast(
                        msg: 'Templates successfully cached',
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Failed to cache templates (${response
                            .statusCode})',
                      );
                    }
                  }).onError((error, stackTrace) {
                    Fluttertoast.showToast(msg: 'Failed to reach server');
                    log('Error while contacting server', error: error);
                  });

                  return true;
                },
              ),
              createTextSettingsTile(
                title: const Text('API Token'),
                leading: const Icon(Icons.token),
                prefKey: apiTokenPrefKey,
                context: context,
                valueAsDescription: true,
                validator: (str) =>
                (str ?? '').isEmpty ? 'Must not be empty' : null,
                onSave: (str) {
                  setState(() {});
                  checkAccessToken(prefs.ensure(apiHostPrefKey), str)
                      .then((value) => null)
                      .onError((error, stackTrace) {
                    Fluttertoast.showToast(
                      msg: 'Error connecting: $error',
                      toastLength: Toast.LENGTH_LONG,
                    );
                  });
                  return true;
                },
              ),
              SettingsTile.switchTile(
                title: const Text('Demo'),
                description: const Text(
                  'Request that the API immediately completes a fake sample',
                ),
                leading: const Icon(Icons.dark_mode),
                initialValue: prefs.get(apiDemoPrefKey),
                onToggle: (value) {
                  prefs.set(apiDemoPrefKey, value);
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Customization'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Use Dark Theme'),
                leading: const Icon(Icons.dark_mode),
                initialValue: prefs.get(darkThemePrefKey),
                onToggle: (isDarkTheme) async {
                  await MyNotifications().show(title: 'Theme Change',
                      body: 'The theme was toggled!');
                  if (!context.mounted) {
                    return;
                  }

                  prefs.set(darkThemePrefKey, isDarkTheme);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
