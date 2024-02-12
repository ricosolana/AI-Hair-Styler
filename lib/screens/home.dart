import 'package:flutter/material.dart';
import 'package:senior_project_hair_ai/screens/editor.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentPage = 'Home';

  void _setPage(String newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  //Function to open the Settings Page
  void _goToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MySettingsPage()),
    );
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
              onPressed: () {
            // Gallery Button
            // TODO: Add logic for the gallery button
          },
            shape: const CircleBorder(),
            child: const Icon(Icons.photo_library,
            size: 28.0,),
            ),
      ),
          const SizedBox(width: 50.0), // Adjust the spacing between buttons
          SizedBox(
            width: 100.0,
            height: 100.0,
          child: FloatingActionButton(
            onPressed: () {
              // Camera Button
              // TODO: Add logic to capture photos
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.add_a_photo,
              size: 48.0,),
          ),
              ),
          const SizedBox(width: 50.0), // Adjust the spacing between buttons
            SizedBox(
              width: 70.0,
              height: 70.0,
              child: FloatingActionButton(
                  onPressed: () {
                    // Undo Button
                    // TODO: Add logic to undo edits (or whatever this button is for)
                  },
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.undo,
                    size: 28.0,),
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
              child:  Text(
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
              onTap: () {
                _setPage('Editor');
                _goToEditor(context);
              },
              ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => _setPage('Gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.directions_walk),
              title: const Text('Walkthrough'),
              // TODO this will actually trigger a walkthrough,
              //  dynamically changing pages and showing caption text, maybe arrows...
              //  the less text the easier to understand (for me at least)
              onTap: () => _setPage('Walkthrough'),
            ),
            const Spacer(), // filler

            //Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                //Go to the 'Help' route
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHelpPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                //Go to the 'About' route
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyAboutPage(),
                    ),
                );
                },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                _setPage('Settings');
                _goToSettings(context);
                },
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

class MyAboutPage extends StatelessWidget {

  const MyAboutPage();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 500.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "About this App: Blah blah blah blah",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHelpPage extends StatelessWidget {

  const MyHelpPage();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 500.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Here's a Helpful Tip: Blah blah blah blah",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
