import 'dart:convert';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/camera_provider.dart';
import 'package:senior_project_hair_ai/notifications.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/capture.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';
import 'package:senior_project_hair_ai/screens/home.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';
import 'package:senior_project_hair_ai/screens/tutorial.dart';
import 'package:senior_project_hair_ai/screens/user_profile.dart';
import 'package:senior_project_hair_ai/screens/work.dart';
import 'package:senior_project_hair_ai/string_ext.dart';
import 'package:senior_project_hair_ai/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';


/*
@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void workBackgroundCallback() {
  Workmanager().executeTask((task, _) async {
    int? totalExecutions;

    // TODO really dont wanna reinvent everything
    //  preferences provider wraps preferences in a both listenable unit and extra functions for preferences

    // TODO implementing user-profiles will complicate this system a lot
    //  maybe prefs will store the current user

    //

    final workItems = prefs.ensure<List<String>>(activeProfileUserIDPrefKey);
    final host = prefs.ensure<String>(apiHostPrefKey);
    final accessToken = prefs.ensure<String>(apiTokenPrefKey);

    try { //add code execution
      final List<Future> futures = [];

      for (final workID in workItems) {
        final cache = DefaultCacheManager();
        final file = await cache.getFileFromCache(
          bapiGeneratedUrl(host, workID).toString(),
        );

        // Skip already received images
        if (file != null) {
          continue;
        }

        futures.add(bapiApiBarberStatus(host: host, accessToken: accessToken, workID: workID)
        .then((response) {
          if (response.statusCode == 200) {
            final json = jsonDecode(response.body) as Map<String, dynamic>;
            final progress = TaskProgress.fromJson(json);
            if (progress.status == 'COMPLETE') {
              // send notification
              MyNotifications().show(
                title: 'Work is complete',
                body: '${workID.limit(8)} has finished processing',
              );
            }
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            // invalid token, stop checking server?
          }
        }).onError((error, stackTrace) {

        }));

        await Future.wait(futures);
      }} catch(err) {
      //Logger().e(err.toString()); // Logger flutter package, prints error on the debug console
      //throw Exception(err);
    }

    return Future.value(true);
  });
}
*/



Future<void> main() async {
  // init camera library
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  Wrapmeras(cameras: await availableCameras());
  Wrapreferences(sharedPrefs: await SharedPreferences.getInstance());



  // init notifications plugin
  await MyNotifications().init();


  // init defaults here
  // TODO default to system theme
  //prefs.getOrCreate(oldDarkThemePrefKey, false);
  prefs.getOrCreate(tutorialCompletedPrefKey, false);
  prefs.getOrCreate(apiHostPrefKey, 'http://10.0.2.2/');
  prefs.getOrCreate(apiCachedTemplateListPrefKey, <String>[]);
  prefs.getOrCreate(apiTokenPrefKey, '');
  prefs.getOrCreate(apiDemoPrefKey, false);

  //prefs.getOrCreate(apiCachedWorkIDListPrefKey, <String>[]);

  //final userProfileDefault = UserProfile(displayName: 'alice');

  // TODO set profile defaults?
  //prefs.getOrCreate(activeProfileUserIDPrefKey, userProfileDefault.getUniqueUserID());
  //prefs.getOrCreate(jsonUserProfilesPrefKey, '[${UserProfile.toJsonString(userProfileDefault)}]');

  UserProfile.load();



  // TODO disable debug mode
  /*
  Workmanager().initialize(
    workBackgroundCallback, // The top level function, aka callbackDispatcher
    isInDebugMode: true, // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  Workmanager().registerPeriodicTask(
    "task-identifier",
    "simpleTask",
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
  );
   */



  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ], 
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B3S',
      // Default app theme template
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: Provider.of<ThemeNotifier>(context).theme,
      home: const MyHomePage(title: "B3S"),
    );
  }
}
