import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyResultsPage extends StatefulWidget {
  const MyResultsPage({super.key});

  @override
  State<MyResultsPage> createState() => _MyResultsPageState();
}

class _MyResultsPageState extends State<MyResultsPage> {
  late XFile imageCachedFile = XFile('');
  String editedPhotoPath = '';

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
              child: editedPhotoPath.isEmpty && imageCachedFile.path.isEmpty
                  ? Image.asset('assets/images/default.png')
                  : editedPhotoPath.isNotEmpty
                      ? Image.file(
                          File(editedPhotoPath),
                          fit: BoxFit.cover,
                        )
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
                    },
                    shape: const CircleBorder(),
                    child: const Icon(Icons.share, size: 45.0),
                  ),
                ),
                SizedBox(
                  width: 85.0,
                  height: 85.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      //TODO Share Photo
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
