import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/Navigation.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/capture.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';
import 'package:senior_project_hair_ai/screens/work.dart';


class MyApeep extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            // Your main content here
            Center(child: Text('Main Content')),
            // SpinKitFadingCircle at the bottom center
            Align(
              alignment: Alignment.bottomCenter,
              child: SpinKitFadingCircle(
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
 }
}

//GlobalKey<State> loadingDialogKey = GlobalKey<State>();

void navigateToEditor(BuildContext context, {String imagePath = '', bool quietSuccess=false}) {
  final host = Provider.of<PreferencesProvider>(context, listen: false).get<String>(apiHostPrefKey)!;
  final accessToken = Provider.of<PreferencesProvider>(context, listen: false).get<String>(apiTokenPrefKey)!;

  // add this to the screen momentarily
  //SpinKitFadingCircle

  showDialog(
    context: context, 
    barrierColor: null, 
    builder: (_) => SpinKitFadingCircle(
      //key: loadingDialogKey, 
      color: Colors.white,
    ),
  );
  //navigateTo(context: context, screen: screen, style: style)

  checkAccessToken(host, accessToken, quietSuccess: quietSuccess)
  .then((valid) {
    Navigator.pop(context); // Pops the loading circle
    if (valid) {
      navigateTo(
        context: context,
        screen: MyEditorPage(
          initialInputImagePath: imagePath,
        ),
        style: NavigationRouteStyle.material,
      );
    }
  }).onError((error, stackTrace) {
    Navigator.pop(context); // Pops the loading circle
    Fluttertoast.showToast(msg: 'Failed to connect: $error', toastLength: Toast.LENGTH_LONG);
  });
  //.whenComplete(() {
  //  if (false) {
  //  Navigator.of(context, rootNavigator: true).pop(loadingDialogKey.currentContext);
  //  }
  //});
}

class MyEditorPage extends StatefulWidget {
  const MyEditorPage({super.key, required this.initialInputImagePath});

  final String initialInputImagePath; //the camera image path will be saved here

  @override
  State<MyEditorPage> createState() => _MyEditorPageState();
}

class _MyEditorPageState extends State<MyEditorPage> {
  /*
    editor
      will contain options relating to ai generation? (more such as weights)
  */

  void styleSelector(int styleIndex) {
    setState(() {
      selectedStyleIndex = styleIndex;
    });
  }

  void colorSelector(int colorIndex) {
    setState(() {
        selectedColorIndex = colorIndex;
    });
  }

  //bool imageChange = false;
  String currentImagePath = '';
  //Uint8List currentImageBytes;
  //bool imageFileExists = false;
  int selectedStyleIndex = -1;
  int selectedColorIndex = -1;
  //File? imageUploaded;

  double _qualityValue = 1.0;

  Future uploadImage() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    
    if (returnedImage == null) {
      return;
    }

    setState(() {
      currentImagePath = returnedImage.path;
      //imageUploaded = File(returnedImage.path);
      //Provider.of<RecentsProvider>(context, listen: false).addFile(returnedImage.path);
      //Provider.of<PreferencesProvider>(context, listen: false).
      Provider.of<PreferencesProvider>(context, listen: false)
          .createListOrAdd(recentsListPrefKey, <String>[returnedImage.path]);
    });
  }

  @override
  void initState() {
    super.initState();
    currentImagePath = widget.initialInputImagePath;
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);

    // TODO ensure prefkey is set
    final cachedTemplatesList =
        prefs.get<List<String>>(apiCachedTemplateListPrefKey)!;

    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Editor'),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Change Image'),
                    content: const Text('Would you like to change this image?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to the gallery here
                          uploadImage();
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(currentImagePath),
                  errorBuilder:(context, error, stackTrace) {
                    return const Icon(Icons.person);
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Text(
            "Select Your Hairstyle: ${selectedStyleIndex != -1 ? selectedStyleIndex.toString() : ''}",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),

          Container(
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.deepPurple, // Border color
                width: 3, // Border width
              ),
              borderRadius: BorderRadius.circular(7), // Border radius
            ),
            child: SingleChildScrollView(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  // TODO recurring issue with settings, perform this at start or somewhere else
                  cachedTemplatesList.length,
                  (index) => GestureDetector(
                    onTap: () {
                      styleSelector(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedStyleIndex == index
                              ? Colors.deepOrangeAccent
                              : Colors.transparent,
                          width: 4,
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: bapiTemplatesUrl(
                          prefs.get<String>(apiHostPrefKey)!,
                          cachedTemplatesList[index],
                        ),
                        progressIndicatorBuilder: (context, url, progress) =>
                            CircularProgressIndicator(
                          value: progress.progress,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      //Image.asset(
                      //  iterate(index),
                      //  fit: BoxFit.cover,
                      //), //Text('Item $index'),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),
          Text(
            "Select Your Hair Color: ${selectedColorIndex != -1 ? selectedColorIndex.toString() : ''}",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),

          /*
          Container(
            height: 100, // Set a smaller height for the container
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.deepPurple, // Border color
                width: 3, // Border width
              ),
              borderRadius: BorderRadius.circular(7), // Border radius
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Colors.redAccent,
                  Colors.brown,
                  Colors.black,
                  Colors.yellow,
                  Colors.white,
                ].asMap().entries.map((entry) {
                  final index = entry.key;
                  final color = entry.value;

                  return GestureDetector(
                    onTap: () {
                      colorSelector(index);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          color: selectedColor == index
                              ? Colors.deepPurpleAccent
                              : Colors.transparent,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),*/

          // TODO repurpose as color selector box
          Container(
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.deepPurple, // Border color
                width: 3, // Border width
              ),
              borderRadius: BorderRadius.circular(7), // Border radius
            ),
            child: SingleChildScrollView(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  // TODO recurring issue with settings, perform this at start or somewhere else
                  cachedTemplatesList.length,
                  (index) => GestureDetector(
                    onTap: () {
                      colorSelector(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedColorIndex == index
                              ? Colors.deepOrangeAccent
                              : Colors.transparent,
                          width: 4,
                        ),
                      ),
                      // TODO apply a blurring to the center of each image?
                      //  maybe to focus the hair, not the face
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: bapiTemplatesUrl(
                              prefs.get<String>(apiHostPrefKey)!,
                              cachedTemplatesList[index],
                            ),
                            progressIndicatorBuilder:
                                (context, url, progress) =>
                                    CircularProgressIndicator(
                              value: progress.progress,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          //ClipOval(
                          //  child: BackdropFilter(
                          //    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          //    child: Container(
                          //      width: 50,
                          //      height: 50,
                          //      color: Colors.transparent,
                          //    ),
                          //  ),
                          //),
                        ],
                      ),
                      //Image.asset(
                      //  iterate(index),
                      //  fit: BoxFit.cover,
                      //), //Text('Item $index'),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Determine the quality (higher looks better but also much slower):",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),

          Slider(
            min: 0,
            max: 100,
            divisions: 100,
            value: _qualityValue,
            label: '${_qualityValue.toInt()}%',
            onChanged: (value) {
              setState(() {
                _qualityValue = value;
              });
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: (selectedColorIndex != -1 && selectedStyleIndex != -1)
                ? () {
                    //if (File(path))

                    // TODO
                    // The API is ready here:
                    final prefs = Provider.of<PreferencesProvider>(
                      context,
                      listen: false,
                    );

                    final host = prefs.get<String>(apiHostPrefKey)!;

                    final styleTemplateFileName = (prefs.get<List<String>>(
                      apiCachedTemplateListPrefKey,
                    )!)[selectedStyleIndex];
                    final colorTemplateFileName = (prefs.get<List<String>>(
                      apiCachedTemplateListPrefKey,
                    )!)[selectedColorIndex];

                    bapiApiBarberPost(
                      host: host,
                      // TODO ensure that pref defaults are loaded prior to this
                      //  SettingsPage is responsible for defaults,
                      //  why duplicate this?
                      accessToken: prefs.get<String>(apiTokenPrefKey)!,
                      // TODO determine what to do with this
                      imagePath: currentImagePath, // require that image actually exists
                      //imageBytes: ,
                      hairStyle: styleTemplateFileName, // 'bob', // style
                      hairColor: colorTemplateFileName, // 'dark-blonde' // color
                      demo: prefs.get(apiDemoPrefKey)!,
                      quality: _qualityValue / 100.0
                    ).then((response) {
                      if (response.statusCode == 200) {
                        // TODO submit to job queue
                        final map =
                            jsonDecode(response.body) as Map<String, dynamic>;

                        // submit to work queue
                        final workID = map['work-id'] as String;

                        prefs.createListOrAdd(
                          apiCachedWorkIDListPrefKey,
                          [workID],
                        );

                        //String imageUrl = apiGeneratedUrl(host, imageName);

                        navigateTo(
                          context: context,
                          //screen: const MyResultsPage(),
                          screen: MyQueuedWorkPage(),
                          style: NavigationRouteStyle.material,
                        );

                        //Fluttertoast.showToast(msg: 'Success! $imageUrl');
                      } else if (response.statusCode == 422) {
                        Fluttertoast.showToast(msg: 'Invalid access token');
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Status Code: ${response.statusCode}',
                        );
                      }
                    }).onError((error, stackTrace) {
                      log(error.toString());
                      Fluttertoast.showToast(
                        msg: 'Failed to connect: $error',
                      );
                    });

                    // Because the AI process takes a while, use a job queue that shows submitted jobs
                    //  When the user sends to the API, the API will respond with a path of the eventual generated image
                    //  as a served file.
                    // The user can query this image path to see if the job has completed.
                    // The job queue will store a list of these job paths for the client to poll
                    //  Polling will query the server for the served image
                    // A non-200 response code means the image does not exist, or that the process is still busy

                    //TODO Values to barbershop, navigate to the final screen, display results
                  }
                : null,
            child: const Text(
              'Generate',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
