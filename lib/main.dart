import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/screens/colors.dart';
import 'package:senior_project_hair_ai/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

// BottomSheet
// Drawer - horizontal sliding window
// Snack bar - bottom alert
// TabBar

Future<void> main() async {
  // init camera library
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDarkTheme = prefs.getBool(darkThemePrefKey) ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          ThemeNotifier(isDarkTheme ? ThemeMode.dark : ThemeMode.light),
      child: MyApp(
        camera: firstCamera,
      ),
    ),
  );

  //runApp(MyApp(camera: firstCamera, themeNotifier: ThemeNotifier(isDarkTheme ? ThemeMode.dark : ThemeMode.light)));

  // base
  //runApp(MyApp(camera: firstCamera));

  // old
  //runApp(
  //  ChangeNotifierProvider(
  //    create: (context) => ThemeProvider(),
  //    child: MyApp(camera: firstCamera),
  //  ),
  //);
}

class MyApp extends StatelessWidget {
  //MyApp({super.key, required this.camera, required this.themeNotifier});

  const MyApp({super.key, required this.camera});

  final CameraDescription camera;
  //final ThemeNotifier themeNotifier;

  //bool _isDarkTheme = false;
  //final _appKey = GlobalKey();

  //@override
  //void initState() {
  //
  //}

  @override
  Widget build(BuildContext context) {
    //final prefs = await SharedPreferences.getInstance();
    //prefs.getBool()

    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      //key: _appKey,
      title: 'Hair Styler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: themeNotifier.themeMode, // use saved pref, not built-in
      home: MyHomePage(title: "Ai_Hair_Styler", camera: camera),
    );

    //return ValueListenableBuilder<ThemeMode>(
    //  valueListenable: themeNotifier,
    //  builder: (context, themeMode, child) {
    //    return MaterialApp(
    //      //key: _appKey,
    //      title: 'Hair Styler',
    //      theme: ThemeData(
    //        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //        useMaterial3: true,
    //        brightness: Brightness.light,
    //      ),
    //      darkTheme: ThemeData(
    //        brightness: Brightness.dark,
    //      ),
    //      themeMode: themeMode, // use saved pref, not built-in
    //      home: MyHomePage(title: "Ai_Hair_Styler", camera: camera),
    //    );
    //  },
    //);
  }
}
