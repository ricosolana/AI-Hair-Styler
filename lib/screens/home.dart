import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:senior_project_hair_ai/screens/editor.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // TODO generify for photo/file/resource type instead of these placeholders
  List<String> elements = ['apple', 'banana', 'pear', 'orange'];

  void _setScreen(
      BuildContext context, Widget Function(BuildContext) newScreen) {
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
            Flexible(
              child: ListView.separated(
                separatorBuilder: (ctx, index) => const Divider(
                  color: Colors.grey,
                ),
                itemCount: elements.length,
                itemBuilder: (ctx, index) => GestureDetector(
                  onTap: Feedback.wrapForTap(() => debugPrint('index $index clicked'), ctx),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(elements[index])),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ListTile(
                leading: const Icon(Icons.camera),
                onTap: () => {
                  // https://docs.flutter.dev/cookbook/plugins/picture-using-camera

                  // Access the camera, take a photo, then open editor
                },
              ),
            ),
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
              onTap: () => {
                _setScreen(
                  context,
                  (ctx) => const MyEditorPage(),
                ),
              },
            ),
            const ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              // TODO onTap
            ),
            const ListTile(
              leading: Icon(Icons.directions_walk),
              title: Text('Walkthrough'),
              // TODO onTap
            ),
            const Spacer(),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              // TODO onTap
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              // TODO onTap
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => _setScreen(context, (ctx) => const MySettingsPage()),
            ),
          ],
        ),
      ),
    );
  }
}
