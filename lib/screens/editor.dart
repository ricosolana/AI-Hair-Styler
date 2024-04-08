import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/Navigation.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/capture.dart';
import 'package:senior_project_hair_ai/screens/results.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';

// TODO properly implement

class MyEditorPage extends StatefulWidget {
  const MyEditorPage({super.key, required this.inputImagePath});

  final String inputImagePath; //the camera image path will be saved here

  @override
  State<MyEditorPage> createState() => _MyEditorPageState();
}

class _MyEditorPageState extends State<MyEditorPage> {
  /*
    editor
      will contain options relating to ai generation? (more such as weights)
  */

  void styleSelector(int styleIndex) {
    setState(() {
      if (selectedStyle == styleIndex) {
        selectedStyle = -1;
      } else {
        selectedStyle = styleIndex;
      }
    });
  }

  void colorSelector(int colorIndex) {
    setState(() {
      if (selectedColor == colorIndex) {
        selectedColor = -1;
      } else {
        selectedColor = colorIndex;
      }
    });
  }

  String iterate(dynamic funIndex) {
    return "assets/images/IMG ($funIndex).png";
  }

  bool imageChange = false;
  //String finalPath = '';
  int selectedStyle = -1;
  int selectedColor = -1;
  File? imageUploaded;

  Future uploadImage() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) {
      return;
    }
    setState(() {
      imageUploaded = File(returnedImage.path);
      //Provider.of<RecentsProvider>(context, listen: false).addFile(returnedImage.path);
      //Provider.of<PreferencesProvider>(context, listen: false).
      Provider.of<PreferencesProvider>(context, listen: false)
          .createListOrAdd(recentsListPrefKey, <String>[returnedImage.path]);
      //finalPath = returnedImage.path;
      imageChange = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Editor'),
      ),
      body: ListView(
        children: <Widget>[
            Container(
              height: 160.0,
              color: Colors.red,
            ),
            Container(
              height: 160.0,
              color: Colors.blue,
            ),
            Container(
              height: 160.0,
              color: Colors.green,
            ),
            Container(
              height: 160.0,
              color: Colors.yellow,
            ),
            Container(
              height: 160.0,
              color: Colors.orange,
            ),
            Container(
              height: 160.0,
              color: Colors.amber,
            ),
            Container(
              height: 160.0,
              color: Colors.cyan,
            ),
            Container(
              height: 160.0,
              color: Colors.deepOrange,
            ),
            Container(
              height: 160.0,
              color: Colors.indigo,
            ),
            Container(
              height: 160.0,
              color: Colors.orange,
            ),
            Container(
              height: 160.0,
              color: Colors.pink,
            ),
            Container(
              height: 160.0,
              color: Colors.lime,
            ),
            Container(
              height: 160.0,
              color: Colors.orange,
            ),
        ],
        )
    );
  }
}
