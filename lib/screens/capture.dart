import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:convert_native_img_stream/convert_native_img_stream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imglib;

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<String> imagePaths = [];
  final nativeConvert = ConvertNativeImgStream();

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.

    final camera = Provider.of<CameraDescription>(context, listen: false);

    _controller = CameraController(
      camera,
      ResolutionPreset.low,
    );

    // TODO ffi?
    // https://medium.com/@hugand/capture-photos-from-camera-using-image-stream-with-flutter-e9af94bc2bee
    _initializeControllerFuture = _controller.initialize().then((_) async {
      _controller.startImageStream((image) async { 
        final jpegByte = await nativeConvert.convertImgToBytes(image.planes.first.bytes, image.width, image.height, quality: 90);

        // Android: image.format.group: yuv420
        final client = http.Client();
        try {
          // https://medium.com/kbtg-life/real-time-machine-learning-with-flutter-camera-bbcf1b5c3193#d4a0

          //final jpgImage = imglib.decodeImage(image.planes[0].bytes);

          //final response = await client.post(
          //    Uri.http('10.0.2.2', 'api/svoji'),
          //    body: {'image': imglib.encodeJpg(jpgImage!)});

          final response = await client.post(
              Uri.http('10.0.2.2', 'api/svoji'),
              body: {'image': jpegByte});

          final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
          //final uri = Uri.parse(decodedResponse['uri'] as String);
          //log(client.get(uri).toString());
          log(decodedResponse.toString());
        } finally {
          client.close();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPictureTaken(String path) {
    setState(() {
      imagePaths.add(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Take a Picture of:")),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20), // Add some spacing
          Text(
            imagePaths.isEmpty
                ? "Your face from the front (1/4)"
                : imagePaths.length == 1
                    ? "The LEFT side of your head (2/4)"
                    : imagePaths.length == 2
                        ? "The RIGHT side of your head (3/4)"
                        : "The BACK of your head (4/4)",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20), // Add some spacing
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Expanded(child: CameraPreview(_controller));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 100.0,
        width: 100.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final image = await _controller.takePicture();
                if (!context.mounted) return;
                _onPictureTaken(image.path);
                if (imagePaths.length >= 4) {
                  // Navigate to the DisplayPictureScreen after taking all four pictures
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          DisplayPictureScreen(imagePaths: imagePaths),
                    ),
                  );

                  // Clear the imagePaths list after navigating back
                  setState(() {
                    imagePaths.clear();
                  });
                }
              } catch (e) {
                log(e.toString());
              }
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.camera_alt, size: 28.0),
          ), // Align button to the middle
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final List<String> imagePaths;
  final List<String> captions = ['Front', 'Left', 'Right', 'Back'];

  DisplayPictureScreen({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    final controller = PageController(
      initialPage: 1000, // Start at a large number to enable infinite scrolling
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Your Captures:')),
      body: PageView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          final captionIndex = index % captions.length;
          final imagePathIndex = index % imagePaths.length;

          return Column(
            children: [
              const SizedBox(height: 20), // Add padding above the caption
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  captions[captionIndex],
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Image.file(
                  File(imagePaths[imagePathIndex]),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                  height: 20), // Add spacing between image and button
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          // Add functionality for the "Edit" button here
        },
        shape: const CircleBorder(),
        child: const Icon(
          Icons.auto_fix_high_rounded,
          size: 50.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
