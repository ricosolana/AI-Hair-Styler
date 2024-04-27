import 'dart:convert';
import 'dart:io';

import 'package:app_tutorial/app_tutorial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/Navigation.dart';
import 'package:senior_project_hair_ai/listenable.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/about.dart';
import 'package:senior_project_hair_ai/screens/capture.dart';
import 'package:senior_project_hair_ai/screens/editor.dart';
import 'package:senior_project_hair_ai/screens/help.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';
import 'package:senior_project_hair_ai/screens/tutorial.dart';
import 'package:senior_project_hair_ai/screens/user_profile.dart';
import 'package:senior_project_hair_ai/screens/work.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  late String activeUserDisplayName;

  void _setCurrentProfile({String ?userID}) {
    setState(() {
      if (userID == null) {
        activeUserDisplayName = UserManager.getUserDisplayName(prefs.ensure(activeProfileUserIDPrefKey))!;
      } else {
        activeUserDisplayName = UserManager.getUserDisplayName(userID)!;
      }
    });
  }

  //@override
  //void initState() {
  //  super.initState();
  //  // Assign the GlobalKey to the button
  //  //((_scaffoldKey.currentState!.widget.appBar!) as AppBar).leading.key = ValueKey('hamburgerButton');
  //}

  Future<void> uploadImage() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    //final returnedImage = await FilePicker.platform.pickFiles(
    //  type: FileType.custom,
    //  allowedExtensions: ['jpg', 'jpeg', 'png'],
    //);
    if (returnedImage == null) {
      return;
    }

    //Provider.of<PreferencesProvider>(context).createListOrAdd(recentsListPrefKey, [returnedImage.path]);
    setState(() {
      //Provider.of<PreferencesProvider>(context, listen: false)
      //.createListOrAdd(recentsListPrefKey, [result.paths.first!]);

      prefs.createListOrAdd(recentsListPrefKey, [returnedImage.path]);
    });
  }

  void _tryStartTutorial() {
    if (!prefs.get<bool>(tutorialCompletedPrefKey)!) {
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
          title: 'Refresh button',
          content: 'Press this to clear the list of recently uploaded photos',
        ),
      ),
    });
  }

  @override
  void initState() {
    super.initState();

    initTutorialItems();
    _tryStartTutorial();

    _setCurrentProfile();
  }

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${widget.title} (Home)"),
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
                'Upload or Take a Photo to Get Started',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22.0,
                ),
              ),
            ),
            const Text(
              "(Recently Edited Images will appear below)",
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ), // Add padding to the bottom
                child: Stack(
                  children: [
                    // TODO use Listview.builder(...)
                    ListView(
                      padding: const EdgeInsets.only(bottom: 150),
                      children: prefs
                          .get<List<String>>(recentsListPrefKey)!
                          .reversed
                          .map((path) {
                            return ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  Expanded(
                                    child: Center(
                                      child: Image.file(
                                        File(path),
                                        width: 150,
                                        cacheWidth: (150 * devicePixelRatio)
                                            .round(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      path.length > 20
                                          ? '...${path.substring(path.length - 20)}'
                                          : path,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22.0,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              onTap: () => navigateToEditor(
                                context,
                                imagePath: path,
                                quietSuccess: true,
                              ),
                            );
                          })
                          .toList(),
                    ),
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
          // Upload image from gallery
          SizedBox(
            width: 80.0,
            height: 80.0,
            child: FloatingActionButton(
              heroTag: "home-upload-fab",
              key: uploadFloatingKey,
              onPressed: () {
                // Upload Button
                uploadImage();
              },
              shape: const CircleBorder(),
              child: const Icon(
                Icons.file_upload_rounded,
                size: 40.0,
              ),
            ),
          ),
          const SizedBox(width: 50.0),
          // Prepare a capture to upload
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: FloatingActionButton(
              heroTag: "home-capture-fab",
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
                size: 55.0,
              ),
            ),
          ),
          const SizedBox(width: 50.0), // Adjust the spacing between buttons
          SizedBox(
            width: 80.0,
            height: 80.0,
            child: FloatingActionButton(
              heroTag: 'home-clear-fab',
              key: editorFloatingKey,
              onPressed: () {
                // TODO add a list clear to PreferencesProvider
                //Provider.of<RecentsProvider>(context, listen: false).clearFiles();
                // MUST trigger the change post-clear
                setState(() {
                  // not necessary here
                  prefs.set(recentsListPrefKey, <String>[]);
                });
              },
              shape: const CircleBorder(),
              child: Icon(
                MdiIcons.trashCan,
                size: 40.0,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(activeUserDisplayName),
              accountEmail: null, //Text('john.doe@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  //activeUserProfile.g, // 'JD',
                  UserManager.getAbbreviation(activeUserDisplayName), /// 'test',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              onDetailsPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final lvUpdateNotifier = UpdateNotifier();
                    return AlertDialog(
                      title: const Text('Switch Profile'),
                      content: SizedBox(
                        height: 300.0,
                        width: 300.0,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListenableBuilder(
                                listenable: lvUpdateNotifier, // actually do not destroy
                                builder: (context, child) {
                                  // will dynamically rebuild?
                                  final entriesList = UserManager.users.entries.toList();
                                  return ListView.builder( // TODO use .builder
                                    itemCount: entriesList.length,
                                    itemBuilder: (context, index) {
                                      // todo build profiles here
                                      // Row(children: <Widget>[Container()])
                                      final enumUser = entriesList[index];
                                      final enumUserDisplayName = enumUser
                                          .value;
                                      final enumUserID = enumUser.key;
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            //activeUserProfile.g, // 'JD',
                                            UserManager.getAbbreviation(
                                                activeUserDisplayName),

                                            /// 'test',
                                            //style: TextStyle(fontSize: 40.0),
                                          ),
                                        ),
                                        //leading: const CircleAvatar(), // const Icon(Icons.person),
                                        title: Text(enumUserDisplayName),
                                        // Display name
                                        subtitle: Text(enumUserID),
                                        // id
                                        onTap: () {
                                          // TODO switch to profile
                                          Navigator.pop(context);
                                          _setCurrentProfile(
                                              userID: enumUserID);
                                        },
                                      );
                                    },
                                  );
                                }
                              ),
                            ),
                            // TODO bottom static add profile
                            ListTile(
                              leading: const Icon(Icons.person_add),
                              title: const Text('Add Profile'),
                              onTap: () {
                                // Add a new profile
                                // TODO create a new after prompting


                                final _textController = TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Enter Text'),
                                      content: TextFormField(
                                        controller: _textController,
                                        decoration: InputDecoration(hintText: "Enter the display name"),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Do something with the text input
                                            //print(_textController.text);
                                            final baseUserID = _textController.text.toLowerCase().replaceAll(' ', '_');
                                            late String uniqueUserID;
                                            for (var i=0; i < 999999999999; i++) {
                                              uniqueUserID = '$baseUserID$i'; // like crzi1
                                              // Will try to create a user, loop until successful
                                              if (UserManager.createUser(uniqueUserID, _textController.text)) {
                                                break;
                                              }
                                            }

                                            // immediately switch to the profile

                                            //Fluttertoast.showToast(msg: 'Created')
                                            Navigator.of(context).pop();

                                            _setCurrentProfile(userID: uniqueUserID);
                                            lvUpdateNotifier.update();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );




                                //Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),



            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'B3S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editor'),
              onTap: () => navigateToEditor(context, quietSuccess: true),
              //() => navigateTo(
              //  context: context,
              //  screen: const MyEditorPage(
              //    initialInputImagePath: '',
              //  ),
              //  style: NavigationRouteStyle.material,
              //),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => uploadImage(),
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
            const Divider(),
            ListTile(
              leading: Icon(MdiIcons.cloudClock),
              title: const Text('Queued Tasks'),
              onTap: () {
                // open work queue
                navigateTo(
                  context: context,
                  //screen: const MyResultsPage(),
                  screen: MyQueuedWorkPage(),
                  style: NavigationRouteStyle.material,
                );
              },
            ),
            //const Spacer(), // filler
            Row(children: <Widget>[Container()]), // TODO this adds empty middle-spacing
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
    );
  }
}
