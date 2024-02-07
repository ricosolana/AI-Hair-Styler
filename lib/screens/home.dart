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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You are currently on page:',
            ),
            Text(
              '$_currentPage',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Flexible(
              //height: 200,
              /*
              child: Center(
                child: ListView(children: <Widget>[
                // TODO these elements will be dynamically
                //  added, removed, and rearranged
                ListTile(
                  leading: const Icon(Icons.one_k),
                )
              ])),
              */
              /*
              child: ListView(shrinkWrap: true, children: <Widget>[
                // TODO these elements will be dynamically
                //  added, removed, and rearranged
                Center(
                    child: ListTile(
                  leading: const Icon(Icons.one_k),
                ))
              ]),*/
              // try 2
              child: ListView(shrinkWrap: true, children: <Widget>[
                // TODO these elements will be dynamically
                //  added, removed, and rearranged
                Container(
                    width: double.infinity,
                    child: Center(
                        child: ListTile(
                      leading: const Icon(Icons.one_k),
                    )))
              ]),
            ),
            Spacer(),
            ListTile(
              leading: const Icon(Icons.camera),
            )
            /*
            SizedBox(
              height: 200,
              child: ListView(children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera),
                )
              ]),
            )*/
            //Expanded(child: )
            //Spacer(), // Icons.photo_camera or
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: const Text(
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
            Spacer(), // filler

            //Spacer(),
            Divider(),
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
            Divider(),
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
