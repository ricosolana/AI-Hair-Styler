import 'package:flutter/material.dart';
import 'package:senior_project_hair_ai/screens/home.dart';

// BottomSheet
// Drawer - horizontal sliding window
// Snack bar - bottom alert
// TabBar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hair Styler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: "Ai_Hair_Styler"),
    );
  }
}

