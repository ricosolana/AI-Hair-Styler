import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_project_hair_ai/Navigation.dart';
import 'package:senior_project_hair_ai/screens/about.dart';
import 'package:senior_project_hair_ai/screens/editor.dart';
import 'package:senior_project_hair_ai/screens/gallery.dart';
import 'package:senior_project_hair_ai/screens/help.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentPage = 'Home';
  List<String> recentCaptures = [
    "path/to/recents/a",
    "path/to/recents/b",
    "path/to/recents/c",
    "path/to/recents/d",
    "path/to/recents/e",
    "path/to/recents/f",
    "path/to/recents/g",
    "path/to/recents/h",
    "path/to/recents/i",
    "path/to/recents/j",
    "path/to/recents/k",
    "path/to/recents/l",
  ];

  void _setPage(String newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  //Function to open the Editor Page
  void _goToEditor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyEditorPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
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
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 120),
                shrinkWrap: true,
                itemCount: recentCaptures.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Center(
                      child: Row(
                        children: [
                          const Spacer(
                            flex: 2,
                          ),
                          Expanded(
                            // TODO make this load the image or fail, omit if missing? best to warn
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/smiley.svg',
                                width: 50,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '(Recently Edited Photo ${index + 1})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      //TODO: Add logic to open recently edited photo
                    },
                  );
                },
              ),
            ],
          ),
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
              onPressed: () {
                // Upload Button
                // TODO: Add logic for the upload button
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
              onPressed: () {
                // Camera Button
                // TODO: Add logic to capture photos
                // 
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
              onTap: () => navigateTo(context: context, screen: const MyEditorPage(), style: NavigationRouteStyle.material),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => navigateTo(context: context, screen: const MyGalleryPage(), style: NavigationRouteStyle.material),
            ),
            ListTile(
              leading: const Icon(Icons.directions_walk),
              title: const Text('Walkthrough'),
              // TODO this will actually trigger a walkthrough,
              //  dynamically changing pages and showing caption text, maybe arrows...
              //  the less text the easier to understand (for me at least)
              onTap: () {
                // start walkthrough

              }
            ),
            const Spacer(), // filler
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () => navigateTo(context: context, screen: const MyHelpPage(), style: NavigationRouteStyle.material),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => navigateTo(context: context, screen: const MyAboutPage(), style: NavigationRouteStyle.material),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => navigateTo(context: context, screen: const MySettingsPage(), style: NavigationRouteStyle.material),
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
