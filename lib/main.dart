import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/camera_provider.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';
import 'package:senior_project_hair_ai/screens/home.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';
import 'package:senior_project_hair_ai/screens/tutorial.dart';
import 'package:senior_project_hair_ai/screens/work.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // init camera library
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = CameraProvider(cameras: await availableCameras());

  final prefs =
      PreferencesProvider(prefs: await SharedPreferences.getInstance());

  // init defaults here
  prefs.getOrDefault(tutorialCompletedPrefKey, false);
  prefs.getOrDefault(apiHostPrefKey, 'http://10.0.2.2/');
  prefs.getOrDefault(apiCachedTemplateListPrefKey, <String>[]);
  prefs.getOrDefault(apiTokenPrefKey, '');
  prefs.getOrDefault(apiDemoPrefKey, false);
  prefs.getOrDefault(apiCachedWorkIDListPrefKey, <String>[]);
  prefs.getOrDefault(apiTimeoutPrefKey, 5);

  runApp(
    MultiProvider(
      providers: [
        //Provider.value(value: prefs),
        ChangeNotifierProvider.value(value: prefs),
        Provider.value(
          value: cameras,
        ),
        // TODO persist the Recents list to disk
        //ChangeNotifierProvider.value(value: RecentsProvider()),
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: prefs.getOr(darkThemePrefKey, false)
          ? ThemeMode.dark
          : ThemeMode.light, // use saved pref, not built-in
      home: const MyHomePage(title: "Hairch"),
    );
  }
}
