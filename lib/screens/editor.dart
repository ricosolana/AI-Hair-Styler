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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Thi
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
  String inputImagePath = ""; //the camera image path will be saved here

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }
  String iterate(dynamic funIndex) {
    return "input/IMG ($funIndex).png";
  }

  @override
  // FAVOUR'S SAMPLE EDITOR PAGE FROM HERE TO LINE 117
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Responsive App'),
      // ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Image.asset(
              "input/IMG (1).png",
              fit: BoxFit.cover,
              height: 200,
            ),
            const SizedBox(height: 20),

//need to start a card here
            // GridView
            Expanded(
              child: SingleChildScrollView(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    20,
                        (index) => Container(
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child:
                        Image.asset(iterate(index)) //Text('Item $index'),
                    ,),
                  ),
                ),
//end card here
              ),
            ),

            const SizedBox(height: 20),
            Container(
              //height: 150,
     padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add your button functionality here
                },
                child: const Text('Button'),
              ),
            )
          ,],
        ),
      ),
    );
  } //END FAVOUR EDITOR PAGE

//OLD EDITOR PAGE
  /*
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

   */
}
