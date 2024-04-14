import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path; //just added
import 'package:path_provider/path_provider.dart'; //just added
import 'package:share_plus/share_plus.dart';

class MyResultsPage extends StatefulWidget {
  const MyResultsPage({super.key});

  @override
  State<MyResultsPage> createState() => _MyResultsPageState();
}

class _MyResultsPageState extends State<MyResultsPage> {
  late XFile imageCachedFile = XFile('assets/images/default.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Final Results"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: imageCachedFile.path.isEmpty
                  // TODO test this icon
                  ? const Icon(
                      Icons.person,) // Image.asset('assets/images/default.png')
                  : Image.file(
                      File(imageCachedFile.path),
                      fit: BoxFit.cover,
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 85.0,
                  height: 85.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      //TODO Share Photo
                      Share.shareXFiles([
                        XFile(imageCachedFile.path),
                      ]); //just added, might need tweaking not sure.
                    },
                    shape: const CircleBorder(),
                    child: const Icon(Icons.share, size: 45.0),
                  ),
                ),
                SizedBox(
                  width: 85.0,
                  height: 85.0,
                  child: FloatingActionButton(
                    onPressed: () async {
                      //TODO Download Photo
                      final Directory documentDirectory =
                          await getApplicationDocumentsDirectory(); //just added
                      final File file = File(path.join(
                          documentDirectory.path, 'filename.jpg',),); //just added
                      await file
                          .writeAsBytes(await imageCachedFile.readAsBytes());
                    },
                    shape: const CircleBorder(),
                    child: const Icon(Icons.download_rounded, size: 45.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
