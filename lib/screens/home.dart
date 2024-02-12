import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentPage = '';

  void _setPage(String newPage) {
    setState(() {
      _currentPage = newPage;
    });
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
          mainAxisAlignment: MainAxisAlignment.start,
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
              onTap: () => _setPage('Editor'),
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
              onTap: () => _setPage('Help'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => _setPage('About'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => _setPage('Settings'),
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
