import 'package:flutter/material.dart';

// TODO properly implement

class MyEditorPage extends StatefulWidget {
  const MyEditorPage({super.key});

  @override
  State<MyEditorPage> createState() => _MyEditorPageState();
}

class _MyEditorPageState extends State<MyEditorPage> {
  /*
    editor
      will contain options relating to ai generation? (more such as weights)
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Editor'),
      ),
      // simplify app,
      // reduce complexity
      // no extra editing features except those few absolutely required
      // aka no cropping, no color changes (for now until main features are implemented)

      // load an image
      //body:
      //Image.network()
      //Center(
      //  child: Column(
      //    mainAxisAlignment: MainAxisAlignment.center,
      //    children: <Widget>[
      //      const Text(
      //        'Hi',
      //      ),
      //    ],
      //  ),
      //),
    );
  }
}
