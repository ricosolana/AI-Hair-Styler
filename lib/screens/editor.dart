import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/Navigation.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/listenable.dart';
import 'package:senior_project_hair_ai/listenable.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/capture.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';
import 'package:senior_project_hair_ai/screens/user_profile.dart';
import 'package:senior_project_hair_ai/screens/work.dart';

Future<void> navigateToEditor(
  BuildContext context, {
  String imagePath = '',
  bool quietSuccess = false,
}) async {
  final host = prefs.get<String>(apiHostPrefKey)!;
  final accessToken = prefs.get<String>(apiTokenPrefKey)!;

  // add this to the screen momentarily
  //SpinKitFadingCircle

  showDialog(
    context: context,
    barrierColor: null,
    builder: (_) => const SpinKitFadingCircle(color: Colors.white),
  );
  //navigateTo(context: context, screen: screen, style: style)

  final valid =
      await checkAccessToken(host, accessToken, quietSuccess: quietSuccess);
  if (!context.mounted) {
    return;
  }

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
}

class MyEditorPage extends StatefulWidget {
  const MyEditorPage({super.key, required this.initialInputImagePath});

  final String initialInputImagePath; //the camera image path will be saved here

  @override
  State<MyEditorPage> createState() => _MyEditorPageState();
}

class _MyEditorPageState extends State<MyEditorPage> {
  String _currentImagePath = '';
  int _selectedStyleIndex = 0;
  int _selectedColorIndex = 0;
  late List<UpdateNotifier> _selectedStyleIndexNotifiers;
  late List<UpdateNotifier> _selectedColorIndexNotifiers;
  final ValueNotifier<double> _qualityValueNotifier = ValueNotifier(1.0);

  late List<String> cachedTemplatesList;

  void _styleSelector(int styleIndex) {
    // TODO update the list old, and new item
    _selectedStyleIndexNotifiers[_selectedStyleIndex].update();
    _selectedStyleIndex = styleIndex;
    _selectedStyleIndexNotifiers[_selectedStyleIndex].update();
  }

  void _colorSelector(int colorIndex) {
    _selectedColorIndexNotifiers[_selectedColorIndex].update();
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
      UserProfile.activeUserProfile().setRecentItems((list) => list.add(returnedImage.path));
    });
  }

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.initialInputImagePath;

    cachedTemplatesList = prefs.get<List<String>>(apiCachedTemplateListPrefKey)!;

    _selectedStyleIndexNotifiers =
        List.generate(cachedTemplatesList.length, (_) => UpdateNotifier());
    _selectedColorIndexNotifiers =
        List.generate(cachedTemplatesList.length, (_) => UpdateNotifier());
  }

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Editor'),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          const Text(
            "Select an Image:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),
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
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Select Your Hairstyle:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),

          /*
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
                        listenable: _selectedStyleIndexNotifiers[
                            index], // _selectedStyleIndex,
                        builder: (context, child) {
                          return Container(
                            decoration: _selectedStyleIndex == index
                                ? BoxDecoration(
                                    border: Border.all(
                                      color: Colors.deepOrangeAccent,
                                      width: 4,
                                    ),
                                  )
                                : null,
                            child: CachedNetworkImage(
                              imageUrl: bapiTemplatesUrl(
                                prefs.get<String>(apiHostPrefKey)!,
                                cachedTemplatesList[index],
                              ),
                              memCacheWidth: (100 * devicePixelRatio).round(),
                              progressIndicatorBuilder:
                                  (context, url, progress) =>
                                      CircularProgressIndicator(
                                value: progress.progress,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          );
                        },),
                  );
                },
              ),
            ),
          ),
           */

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple, // Border color
                  width: 3, // Border width
                ),
                borderRadius: BorderRadius.circular(7), // Border radius
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                          listenable: _selectedStyleIndexNotifiers[index],
                          builder: (context, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: _selectedStyleIndex == index
                                    ? BoxDecoration(
                                        border: Border.all(
                                          color: Colors.deepOrangeAccent,
                                          width: 4,
                                        ),
                                      )
                                    : null,
                                child: CachedNetworkImage(
                                  imageUrl: bapiTemplatesUrl(
                                    prefs.get<String>(apiHostPrefKey)!,
                                    cachedTemplatesList[index],
                                  ).toString(),
                                  memCacheWidth:
                                      (100 * devicePixelRatio).round(),
                                  progressIndicatorBuilder:
                                      (context, url, progress) =>
                                          CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Select Your Hair Color:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple, // Border color
                  width: 3, // Border width
                ),
                borderRadius: BorderRadius.circular(7), // Border radius
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                          listenable: _selectedColorIndexNotifiers[
                              index], // _selectedStyleIndex,
                          builder: (context, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: _selectedColorIndex == index
                                    ? BoxDecoration(
                                        border: Border.all(
                                          color: Colors.deepOrangeAccent,
                                          width: 4,
                                        ),
                                      )
                                    : null,
                                child: CachedNetworkImage(
                                  imageUrl: bapiTemplatesUrl(
                                    prefs.get<String>(apiHostPrefKey)!,
                                    cachedTemplatesList[index],
                                  ).toString(),
                                  memCacheWidth:
                                      (100 * devicePixelRatio).round(),
                                  progressIndicatorBuilder:
                                      (context, url, progress) =>
                                          CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            child: Text(
              textAlign: TextAlign.center,
              "Determine the quality (the higher the quality the longer the compute time):",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _qualityValueNotifier,
            // TODO (actually for everything)
            //  make everything dynamically positioned for different devices
            //  since this apparently is statically positioned, might be cut
            //  off or weirdly sized depending on the device
            builder: (context, value, child) => Center(
              child: SizedBox(
                width: 350,
                child: Slider(
                  max: 100,
                  divisions: 100,
                  value: _qualityValueNotifier.value,
                  label:
                      '${_qualityValueNotifier.value.toStringAsFixed(1)}%', // '${_qualityValue.toInt()}%',
                  onChanged: (value) {
                    _qualityValueNotifier.value = value;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
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
                imagePath:
                    _currentImagePath, // require that image actually exists
                //imageBytes: ,
                hairStyle: styleTemplateFileName, // 'bob', // style
                hairColor: colorTemplateFileName, // 'dark-blonde' // color
                demo: prefs.get(apiDemoPrefKey)!,
                quality: _qualityValueNotifier.value / 100.0,
              ).then((response) {
                if (response.statusCode == 200) {
                  // TODO submit to job queue
                  final map = jsonDecode(response.body) as Map<String, dynamic>;

                  // submit to work queue
                  final workID = map['work-id'] as String;

                  UserProfile.activeUserProfile().setWorkItems((list) => list.add(workID));

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
            },
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
