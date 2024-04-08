import 'dart:io';

import 'package:app_tutorial/app_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/Navigation.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/recents_provider.dart';
import 'package:senior_project_hair_ai/screens/about.dart';
import 'package:senior_project_hair_ai/screens/capture.dart';
import 'package:senior_project_hair_ai/screens/editor.dart';
import 'package:senior_project_hair_ai/screens/gallery.dart';
import 'package:senior_project_hair_ai/screens/help.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';
import 'package:senior_project_hair_ai/screens/tutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentPage = 'Home';

  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  //final hamburgerKey = ValueKey();

  //final drawerKey = ValueKey('drawer_button');
  //final uploadFloatingKey = GlobalKey('uploadFloatingButton');
  //final captureFloatingKey = ValueKey('captureFloatingButton');
  //final editorFloatingKey = ValueKey('editorFloatingButton');
  //final editorKey = ValueKey('editorDrawerButton');
  //final galleryKey = ValueKey('galleryDrawerButton');
  //final walkthroughKey = ValueKey('walkthroughDrawerButton');
  //final settingsKey = ValueKey('settingsDrawerButton');

  final uploadFloatingKey = GlobalKey();
  final captureFloatingKey = GlobalKey();
  final editorFloatingKey = GlobalKey();
  final editorKey = GlobalKey();
  final galleryKey = GlobalKey();
  final walkthroughKey = GlobalKey();
  final settingsKey = GlobalKey();

  List<TutorialItem> tutorialItems = [];

  //@override
  //void initState() {
  //  super.initState();
  //  // Assign the GlobalKey to the button
  //  //((_scaffoldKey.currentState!.widget.appBar!) as AppBar).leading.key = ValueKey('hamburgerButton');
  //}

  void _setPage(String newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  // TODO what is this stored as a field for?
  File? imageUploaded;

  Future uploadImage() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) {
      return;
    }
    setState(() {
      imageUploaded = File(returnedImage.path);
      Provider.of<RecentsProvider>(context, listen: false)
          .addFile(returnedImage.path);
    });
  }

  void _tryStartTutorial() {
    if (!(Provider.of<PreferencesProvider>(context, listen: false)
            .get<bool>(tutorialCompletedPrefKey) ??
        false)) {
      _startTutorial();
    }
  }

  void _startTutorial() {
    Future.delayed(const Duration(microseconds: 200)).then((value) {
      Tutorial.showTutorial(
        context,
        tutorialItems,
        onTutorialComplete: () => setTutorialCompletedPref(context, true),
      );
    });
  }

  void initTutorialItems() {
    tutorialItems.addAll({
      TutorialItem(
        globalKey: uploadFloatingKey,
        child: const TutorialItemContent(
          title: 'Upload button',
          content: 'This is to upload images',
        ),
      ),
      TutorialItem(
        globalKey: captureFloatingKey,
        child: const TutorialItemContent(
          title: 'Capture button',
          content: 'This is to take pictures',
        ),
      ),
      TutorialItem(
        globalKey: editorFloatingKey,
        child: const TutorialItemContent(
          title: 'Editor button',
          content: 'Press this to open the editor for image editing',
        ),
      ),
    });
  }

  @override
  void initState() {
    super.initState();

    initTutorialItems();
    _tryStartTutorial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        //leading: IconButton(
        //  key: ValueKey('hamburgerButton'), // This is the hamburger button
        //  icon: Icon(Icons.menu),
        //  onPressed: () {
        //    _scaffoldKey.currentState.openDrawer();
        //  },
        //),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'You are currently on page:',
              ),
            ),
            Text(
              _currentPage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ), // Add padding to the bottom
                child: Stack(
                  children: [
                    Consumer<RecentsProvider>(
                      builder: (context, recentsProvider, child) {
                        return ListView(
                          padding: const EdgeInsets.only(bottom: 150),
                          children:
                              recentsProvider.savedFiles.reversed.map((path) {
                            return ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  Expanded(
                                    child: Center(
                                      child: Image.file(
                                        File(path),
                                        width: 50,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                      path,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22.0,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              onTap: () {
                                //TODO: ***Open Uploaded/Captured Photo, Navigate to Editing Screen (Colors, Hairstyles, Generate Button)
                                final prefs =
                                    Provider.of<PreferencesProvider>(context, listen: false);
                                apiBarberPost(
                                    prefs.get<String>(apiHostPrefKey)!,
                                    prefs.get<String>(apiTokenPrefKey)!,
                                    //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcxMjQ1NDk3OSwianRpIjoiOWUyMjkyZGMtMzM0OC00MDVhLThkZTQtNWFhNDg4YmVmOGYyIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6ImFub255bW91cyIsIm5iZiI6MTcxMjQ1NDk3OSwiY3NyZiI6IjNjNTgwZmYyLTJiZmEtNDRlZS1iNWJhLTFlNzUxMTg3MzkwZiIsImV4cCI6MTcxMjQ1NTg3OX0.XmkuVZmbKvoautbTq1ez8Ti_PrEuozMBp5HEiFElAG8',
                                    path,
                                    'bob',
                                    'dark-blonde');
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),

                    /*
                    ListView(
                      padding: const EdgeInsets.only(bottom: 150),
                      children: Provider.of<RecentsProvider>(context, listen: false).savedFiles.reversed.map((path) {
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Expanded(
                                child: Center(
                                  child: Image.file(File(path), width: 50,)
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Text(
                                  path,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22.0,
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          onTap: () {
                            //TODO: Add logic to open recently edited photo
                          },
                        );
                      }).toList(),
                    ),
                    */

                    Positioned(
                      top: 500,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.85),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 70.0,
            height: 70.0,
            child: FloatingActionButton(
              heroTag: "upload-fab",
              key: uploadFloatingKey,
              onPressed: () {
                // Upload Button
                // TODO: Add logic for the upload button
                uploadImage();
              },
              shape: const CircleBorder(),
              child: const Icon(
                Icons.file_upload_rounded,
                size: 30.0,
              ),
            ),
          ),
          const SizedBox(width: 50.0), // Adjust the spacing between buttons
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: FloatingActionButton(
              heroTag: "capture-fab",
              key: captureFloatingKey,
              onPressed: () {
                // Camera Button
                navigateTo(
                  context: context,
                  screen: const TakePictureScreen(),
                  style: NavigationRouteStyle.material,
                );
              },
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add_a_photo,
                size: 48.0,
              ),
            ),
          ),
          const SizedBox(width: 50.0), // Adjust the spacing between buttons
          SizedBox(
            width: 70.0,
            height: 70.0,
            child: FloatingActionButton(
              key: editorFloatingKey,
              onPressed: () {
                // AI Edit Button
                // TODO: Add logic to open screen that enables AI edits (or whatever this button is for)
              },
              shape: const CircleBorder(),
              child: const Icon(
                Icons.auto_fix_high_rounded,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Text(
                'AI Hair Styler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editor'),
              onTap: () => navigateTo(
                context: context,
                screen: const MyEditorPage(),
                style: NavigationRouteStyle.material,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => navigateTo(
                context: context,
                screen: const MyGalleryPage(),
                style: NavigationRouteStyle.material,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.directions_walk),
              title: const Text('Walkthrough'),
              // TODO this will actually trigger a walkthrough,
              //  dynamically changing pages and showing caption text, maybe arrows...
              //  the less text the easier to understand (for me at least)
              onTap: () {
                // start walkthrough
                // close drawer
                //navigateTo(context: context, screen: MyHomePage(title: title, camera: camera), style: style)
                // hide drawer
                Navigator.pop(context);
                //Scaffold.of(context).closeEndDrawer();
                _startTutorial();
              },
            ),
            const Spacer(), // filler
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () => navigateTo(
                context: context,
                screen: const MyHelpPage(),
                style: NavigationRouteStyle.material,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => navigateTo(
                context: context,
                screen: const MyAboutPage(),
                style: NavigationRouteStyle.material,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => navigateTo(
                context: context,
                screen: const MySettingsPage(),
                style: NavigationRouteStyle.material,
              ),
            ),
            /*
            Expanded(
                child: ListView(children: <Widget>[
              Align(alignment: FractionalOffset.bottomCenter),
              Divider(color: Colors.grey),

            ]))*/
          ],
        ),
      ),
      onDrawerChanged: (isDrawerOpen) {
        if (!isDrawerOpen) {
          _setPage('Home');
        }
      },
    );
  }
}
