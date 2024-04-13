import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

void navigateToEditor(BuildContext context, {String imagePath = '', bool quietSuccess=false}) {
  final host = Provider.of<PreferencesProvider>(context, listen: false).get<String>(apiHostPrefKey)!;
  final accessToken = Provider.of<PreferencesProvider>(context, listen: false).get<String>(apiTokenPrefKey)!;

  // add this to the screen momentarily
  //SpinKitFadingCircle

  showDialog(
    context: context, 
    barrierColor: null, 
    builder: (_) => const SpinKitFadingCircle(color: Colors.white),
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
  });
}



class EditorItemModel with ChangeNotifier {
  void update() {
    notifyListeners();
  }
}

class MyEditorPage extends StatefulWidget {
  const MyEditorPage({super.key, required this.initialInputImagePath});

  final String initialInputImagePath; //the camera image path will be saved here

  @override
  State<MyEditorPage> createState() => _MyEditorPageState();
}

class _MyEditorPageState extends State<MyEditorPage> {
  String _currentImagePath = '';
  int _selectedStyleIndex = -1; // TODO should we just select index 0 for safety?
  int _selectedColorIndex = -1;
  late List<EditorItemModel> _selectedStyleIndexNotifiers;// = List.generate(length, (index) => null) [];
  late List<EditorItemModel> _selectedColorIndexNotifiers;
  //final _selectedStyleIndexProvider = StatePro
  final ValueNotifier<double> _qualityValueNotifier = ValueNotifier(1.0);

  late List<String> cachedTemplatesList;


  void _styleSelector(int styleIndex) {
    //setState(() {

      // TODO update the list old, and new item
    if (_selectedStyleIndex != -1) {
      _selectedStyleIndexNotifiers[_selectedStyleIndex].update();
    }
    _selectedStyleIndex = styleIndex;
    _selectedStyleIndexNotifiers[_selectedStyleIndex].update();
    //});
  }

  void _colorSelector(int colorIndex) {
    //setState(() {
    // TODO test
      //_selectedColorIndex.value = colorIndex;
    //});
    if (_selectedColorIndex != -1) {
      _selectedColorIndexNotifiers[_selectedColorIndex].update();
    }
    _selectedColorIndex = colorIndex;
    _selectedColorIndexNotifiers[_selectedColorIndex].update();
  }

  Future uploadImage() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    
    if (returnedImage == null) {
      return;
    }

    setState(() {
      _currentImagePath = returnedImage.path;
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
    _currentImagePath = widget.initialInputImagePath;

    final prefs = Provider.of<PreferencesProvider>(context, listen: false);
    cachedTemplatesList = prefs.get<List<String>>(apiCachedTemplateListPrefKey)!;

    _selectedStyleIndexNotifiers = List.generate(cachedTemplatesList.length, (_) => EditorItemModel());
    _selectedColorIndexNotifiers = List.generate(cachedTemplatesList.length, (_) => EditorItemModel());
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);

    // TODO ensure prefkey is set


    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

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
                  File(_currentImagePath),
                  cacheWidth: (200 * devicePixelRatio).round(),
                  errorBuilder:(context, error, stackTrace) {
                    return const Icon(Icons.person);
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Text(
            "Select Your Hairstyle: ${_selectedStyleIndex != -1 ? _selectedStyleIndex.toString() : ''}",
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
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cachedTemplatesList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _styleSelector(index);
                    },
                    child: ListenableBuilder(
                      listenable: _selectedStyleIndexNotifiers[index], // _selectedStyleIndex,
                      builder: (context, child) {
                        return Container(
                          decoration: _selectedStyleIndex == index ?
                            BoxDecoration(
                              border: Border.all(
                                color: Colors.deepOrangeAccent,
                                width: 4,
                              ),
                            ) : null,
                          child: CachedNetworkImage(
                            imageUrl: bapiTemplatesUrl(
                              prefs.get<String>(apiHostPrefKey)!,
                              cachedTemplatesList[index],
                            ),
                            memCacheWidth: (100 * devicePixelRatio).round(),
                            progressIndicatorBuilder: (context, url,
                                progress) =>
                                CircularProgressIndicator(
                                  value: progress.progress,
                                ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        );
                      }
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),
          Text(
            "Select Your Hair Color: ${_selectedColorIndex != -1 ? _selectedColorIndex.toString() : ''}",
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
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cachedTemplatesList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _colorSelector(index);
                    },
                    child: ListenableBuilder(
                        listenable: _selectedColorIndexNotifiers[index], // _selectedStyleIndex,
                        builder: (context, child) {
                          return Container(
                            decoration: _selectedColorIndex == index ?
                              BoxDecoration(
                                border: Border.all(
                                  color: Colors.deepOrangeAccent,
                                  width: 4,
                                ),
                              ) : null,
                            child: CachedNetworkImage(
                              imageUrl: bapiTemplatesUrl(
                                prefs.get<String>(apiHostPrefKey)!,
                                cachedTemplatesList[index],
                              ),
                              memCacheWidth: (100 * devicePixelRatio).round(),
                              progressIndicatorBuilder: (context, url,
                                  progress) =>
                                  CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          );
                        }
                    ),
                  );
                },
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


          ValueListenableBuilder(
              valueListenable: _qualityValueNotifier,
              builder: (context, value, child) => Slider(
                min: 0.0,
                max: 100,
                divisions: 100,
                value: _qualityValueNotifier.value,
                label: _qualityValueNotifier.value.toStringAsFixed(1), // '${_qualityValue.toInt()}%',
                onChanged: (value) {
                  _qualityValueNotifier.value = value;
                },
              ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: (_selectedColorIndex != -1 && _selectedStyleIndex != -1)
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
                    )!)[_selectedStyleIndex];
                    final colorTemplateFileName = (prefs.get<List<String>>(
                      apiCachedTemplateListPrefKey,
                    )!)[_selectedColorIndex];

                    bapiApiBarberPost(
                      host: host,
                      // TODO ensure that pref defaults are loaded prior to this
                      //  SettingsPage is responsible for defaults,
                      //  why duplicate this?
                      accessToken: prefs.get<String>(apiTokenPrefKey)!,
                      // TODO determine what to do with this
                      imagePath: _currentImagePath, // require that image actually exists
                      //imageBytes: ,
                      hairStyle: styleTemplateFileName, // 'bob', // style
                      hairColor: colorTemplateFileName, // 'dark-blonde' // color
                      demo: prefs.get(apiDemoPrefKey)!,
                      quality: _qualityValueNotifier.value / 100.0
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
