import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      // https://github.com/dnfield/flutter_svg/blob/master/packages/flutter_svg_test/test/flutter_svg_test_test.dart
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hi',
            ),
            SvgPicture.asset('assets/images/smiley.svg'),
          ],
        ),
      ),
    );
  }
}
