import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/camera_provider.dart';
import 'package:senior_project_hair_ai/notifications.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';
import 'package:senior_project_hair_ai/screens/home.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';
import 'package:senior_project_hair_ai/screens/tutorial.dart';
import 'package:senior_project_hair_ai/screens/user_profile.dart';
import 'package:senior_project_hair_ai/screens/work.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';



@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void workBackgroundCallback() {
  Workmanager().executeTask((task, _) async {
    int? totalExecutions;

    // TODO really dont wanna reinvent everything
    //  preferences provider wraps preferences in a both listenable unit and extra functions for preferences

    // TODO implementing user-profiles will complicate this system a lot
    //  maybe prefs will store the current user

    //

    //final workIDs = PreferencesProvider.instance.get(prefKey)[apiCachedWorkIDListPrefKey] as List<String>;

    try { //add code execution
      //bapiApiBarberStatus(host: host, accessToken: accessToken, workID: workID)
      //totalExecutions = _sharedPreference.getInt("totalExecutions");
      //_sharedPreference.setInt("totalExecutions", totalExecutions == null ? 1 : totalExecutions+1);
    } catch(err) {
      //Logger().e(err.toString()); // Logger flutter package, prints error on the debug console
      throw Exception(err);
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  // init camera library
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  Wrapmeras(cameras: await availableCameras());
  final prefs = Wrapreferences(sharedPrefs: await SharedPreferences.getInstance());



  // init notifications plugin
  await MyNotifications().init();


  // init defaults here
  prefs.getOrCreate(tutorialCompletedPrefKey, false);
  prefs.getOrCreate(apiHostPrefKey, 'http://10.0.2.2/');
  prefs.getOrCreate(apiCachedTemplateListPrefKey, <String>[]);
  prefs.getOrCreate(apiTokenPrefKey, '');
  prefs.getOrCreate(apiDemoPrefKey, false);
  prefs.getOrCreate(apiCachedWorkIDListPrefKey, <String>[]);

  // TODO set profile defaults?
  prefs.getOrCreate(activeProfileUserIDPrefKey, 'crzi');
  prefs.getOrCreate(jsonUserProfilesPrefKey, '{"crzi": "Rico"}');

  UserManager.load();


  // TODO disable debug mode
  /*
  Workmanager().initialize(
    workBackgroundCallback, // The top level function, aka callbackDispatcher
    isInDebugMode: true, // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  Workmanager().registerOneOffTask(
    "task-identifier",
    "simpleTask",
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false
    )
  );*/



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B3S',
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
      home: const MyHomePage(title: "B3S"),
    );
  }
}
