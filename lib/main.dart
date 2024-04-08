import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/recents_provider.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';
import 'package:senior_project_hair_ai/screens/home.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // init camera library
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  final prefs = PreferencesProvider(prefs: await SharedPreferences.getInstance());

  runApp(
    MultiProvider(
      providers: [
        //Provider.value(value: prefs),
        ChangeNotifierProvider.value(
          value: prefs
        ),
        Provider.value(
          value: firstCamera,
        ),
        // TODO persist the Recents list to disk
        ChangeNotifierProvider.value(value: RecentsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<PreferencesProvider>(context);

    return MaterialApp(
      title: 'Hair Styler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: prefs.getOr(darkThemePrefKey, false) ? ThemeMode.dark : ThemeMode.light, // use saved pref, not built-in
      home: const MyHomePage(title: "Ai Hair Styler"),
    );
  }
}
