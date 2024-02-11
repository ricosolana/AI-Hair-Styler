import 'package:flutter/material.dart';
import 'package:senior_project_hair_ai/screens/editor.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //String _currentPage = '';
  // will require more than string
  //  Basically what comprises a recents labeled picture thing?
  //    a name
  //    a path
  //    an image
  //    a date?
  //    an edit count?
  //  keep things simple, but all important?
  List<String> elements = ['apple', 'banana', 'pear', 'orange'];

  //void _setPage(String newPage) {
  //  setState(() {
  //    _currentPage = newPage;
  //  });
  //}

  void _setScreen(BuildContext context, Widget Function(BuildContext) newScreen) {
    Navigator.of(context).push(MaterialPageRoute(builder: newScreen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //const Text(
            //  'You are currently on page:',
            //),
            //Text(
            //  '$_currentPage',
            //  style: Theme.of(context).textTheme.headlineMedium,
            //),
            Flexible(
                child: ListView.separated(
              separatorBuilder: (ctx, index) => const Divider(
                color: Colors.grey,
              ),
              itemCount: elements.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Index $index')),
              ),
            ),
                /*
              child: ListView.builder(itemBuilder: (BuildContext ctx, int index) => {
                return Card()
              })
              */
                /*
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    width: double.infinity, // full width
                    child: Center(
                      // centers horizontally
                      child: ListTile(
                        leading: const Icon(Icons.one_k),
                      ),
                    ),
                  ),
                  // ...
                ],
              ),*/
                ),
            const Spacer(),
            Center(
                child: ListTile(
              leading: const Icon(Icons.camera), //, size: 2.0),
              onTap: () => {
                // https://docs.flutter.dev/cookbook/plugins/picture-using-camera

                // Access the camera
                // Open the editor with the photo passed as the body
                
              },
            ),),
            // ...
          ],
        ),
      ),
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
            // TODO open the editor
            //  options to:
            //    create a resource (take photo)
            //    import a resource (focus on this later)
            //    export / apply the current resource to file
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editor'),
              //onTap: () => _setPage('Editor'),
              onTap: () => {
                // open
                //Navigator.of(context, )
                _setScreen(context, (ctx) => const MyEditorPage(),),
              },
            ),
            const ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              // TODO impl
              //onTap: () => _setPage('Gallery'),
            ),
            const ListTile(
              leading: Icon(Icons.directions_walk),
              title: Text('Walkthrough'),
              // TODO this will actually trigger a walkthrough,
              //  dynamically changing pages and showing caption text, maybe arrows...
              //  the less text the easier to understand (for me at least)
              //onTap: () => _setPage('Walkthrough'),
            ),
            const Spacer(), // filler

            //Spacer(),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              // TODO impl
              //onTap: () => _setPage('Help'),
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              // TODO impl
              //onTap: () => _setPage('About'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => _setScreen(context, (ctx) => const MySettingsPage()),
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
