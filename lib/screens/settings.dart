import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

// TODO properly implement
// https://docs.flutter.dev/cookbook/persistence/key-value

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
              //SettingsTile.switchTile(
              //  title: ,
              //)
            ],
          ),
        ],
      ),
    );
  }
}
