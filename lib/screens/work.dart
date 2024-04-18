import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';

enum WorkPopupItems {
  save,
  copyFileName,
  copyUrl,
}

const String apiCachedWorkIDListPrefKey = 'api-cached-work-list';

class MyQueuedWorkPage extends StatefulWidget {
  @override
  _MyQueuedWorkPageState createState() => _MyQueuedWorkPageState();
}

// TODO for dynamic progress bars
class WorkItemModel with ChangeNotifier {
  void update() {
    notifyListeners();
  }
}

class _MyQueuedWorkPageState extends State<MyQueuedWorkPage> {
  //List<String> workIDs = [];
  //Map<String, String> workIDStatuses = {};



  WorkPopupItems? selectedItem;
  //late List<WorkItemModel> _refreshNotifiers;
  //late StreamController<TaskProgress> _controller;
  //late Timer _timer;

  Stream<TaskProgress> fetchJobStatusPeriodically(String workID) {
    return Stream.periodic(const Duration(seconds: 1), (count) async {
      // Simulate fetching data from the server
      // Replace this with your actual data fetching logic
      return await _checkBarberStatus(workID);
    }).asyncMap((event) async {
      // Assuming _fetchJobStatusFromServer returns a Future<TaskProgress>
      return await event;
    });
  }

  @override
  void initState() {
    super.initState();

    final prefs = Provider.of<PreferencesProvider>(context, listen: false);

    /*
    // Refresh sub
    //_timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {});
    _controller = StreamController<TaskProgress>(
      onListen: () async {
        //  TODO eventually read individual hosts based on file
        final host = prefs.get<String>(apiHostPrefKey)!;
        final accessToken = prefs.get<String>(apiTokenPrefKey)!;
        // TODO whether this close gets called on widget dispose
        while (!_controller.isClosed) {
          //final prefs = Provider.of<PreferencesProvider>(context, listen: false);
          // just add the
          //
          await Future.delayed(const Duration(seconds: 1));
          await getBarberStatus(host, accessToken, workID)
              .then((value) => controller.add(value))
              .onError((error, stackTrace) => controller.close());
          //controller.add(await getBarberStatus(host, accessToken, workID));
        }
        await controller.close();
      },
    );*/


  }

  @override
  void dispose() {
    //_timer.cancel(); // Cancel the timer when the widget is disposed to avoid memory leaks
    super.dispose();
  }

  Future<TaskProgress> _checkBarberStatus(String workID) async {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);
    final host = prefs.get<String>(apiHostPrefKey)!;
    final accessToken = prefs.get<String>(apiTokenPrefKey)!;

    return getBarberStatus(host, accessToken, workID);
  }


  /*
  //  are prefs even passable
  //  what will stream pass through to streambuilder
  //    wrap deserialized TaskStatus'
  final Stream<TaskProgress> _stream = ((PreferencesProvider prefs, String workID) {
  // TODO the plan here would be to pass required params
  //final Stream<TaskProgress> _stream = ((String host, String accessToken, String workID) {
    late final StreamController<TaskProgress> controller;
    controller = StreamController<TaskProgress>(
      onListen: () async {
        //  TODO eventually read individual hosts based on file
        final host = prefs.get<String>(apiHostPrefKey)!;
        final accessToken = prefs.get<String>(apiTokenPrefKey)!;
        // TODO whether this close gets called on widget dispose
        while (!controller.isClosed) {
          //final prefs = Provider.of<PreferencesProvider>(context, listen: false);
          // just add the
          //
          await Future.delayed(const Duration(seconds: 1));
          await getBarberStatus(host, accessToken, workID)
              .then((value) => controller.add(value))
              .onError((error, stackTrace) => controller.close());
          //controller.add(await getBarberStatus(host, accessToken, workID));
        }
        await controller.close();
      },
    );
    return controller.stream;
  })();*/



  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);
    final cachedWorkIDList =
        prefs.get<List<String>>(apiCachedWorkIDListPrefKey)!;

    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Work Queue"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: cachedWorkIDList.reversed.map((workID) {
                  final host = prefs.get<String>(apiHostPrefKey)!;
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //const Spacer(),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: bapiGeneratedUrl(host, workID),
                              memCacheWidth: (100 * devicePixelRatio)
                                  .round(),
                              progressIndicatorBuilder:
                                  (context, url, progress) =>
                                  CircularProgressIndicator(
                                    value: progress.progress,),
                              errorListener: (obj) {
                                log(obj.toString());
                              },
                              errorWidget: (context, url, error) {
                                // TODO show status/progress
                                return StreamBuilder<TaskProgress>(
                                  stream: fetchJobStatusPeriodically(workID),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      // somewhat unexpected for the API to not respond
                                      return Icon(MdiIcons.serverOff);
                                    } else {
                                      final progress = snapshot.data!;
                                      // TODO include predictive / reconciliation loading...

                                      return Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          if (progress.currentTransformerPercentage != null)

                                            TweenAnimationBuilder<double>(
                                              // TODO check if tween bounds require [0,1]
                                              //tween: Tween<double>(begin: 0, end: progress.),
                                              tween: Tween<double>(begin: 0, end: progress.currentTransformerPercentage!.toDouble() / 100.0),
                                              // TODO test
                                              duration: const Duration(seconds: 1),
                                              builder: (BuildContext context, double tweenValue, Widget? child) {
                                                return CircularProgressIndicator(
                                                  value: tweenValue,
                                                  strokeWidth: 10,
                                                );
                                              },
                                              child: const Icon(Icons.aspect_ratio),
                                            ),
                                            //CircularProgressIndicator(
                                            //  value: progress.currentTransformerPercentage!.toDouble() / 100.0,
                                            //  strokeWidth: 10,
                                            //),
                                          Center(
                                            child: Text(progress.status),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            workID, //cachedImageWorkName.limit(40),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        PopupMenuButton<WorkPopupItems>(
                          initialValue: selectedItem,
                          onSelected: (WorkPopupItems item) async {
                            switch (item) {
                              // TODO grey-out menu item if work is not completed
                              case WorkPopupItems.save:
                                // trigger save?
                                final cache = DefaultCacheManager();
                                final file = await cache.getFileFromCache(
                                    bapiGeneratedUrl(host, workID),);

                                if (file != null) {
                                  final params = SaveFileDialogParams(
                                      sourceFilePath: file.file.path,
                                      fileName: workID +
                                          path.extension(file.file.basename),);
                                  final filePath =
                                      await FlutterFileDialog.saveFile(
                                          params: params,);

                                  Fluttertoast.showToast(
                                      msg: 'Saved to directory $filePath',
                                      toastLength: Toast.LENGTH_LONG,);
                                }

                              case WorkPopupItems.copyFileName:
                                await Clipboard.setData(
                                  ClipboardData(
                                    text: workID,
                                  ),
                                );
                                Fluttertoast.showToast(msg: 'Copied filename');
                              case WorkPopupItems.copyUrl:
                                await Clipboard.setData(
                                  ClipboardData(
                                    text: bapiGeneratedUrl(host, workID),
                                  ),
                                );
                                Fluttertoast.showToast(
                                    msg: 'Copied generated url',);
                            }
                            setState(() {
                              selectedItem = item;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<WorkPopupItems>>[
                            const PopupMenuItem<WorkPopupItems>(
                              value: WorkPopupItems.save,
                              child: Text('Save'),
                            ),
                            const PopupMenuItem<WorkPopupItems>(
                              value: WorkPopupItems.copyFileName,
                              child: Text('Copy file name'),
                            ),
                            const PopupMenuItem<WorkPopupItems>(
                              value: WorkPopupItems.copyUrl,
                              child: Text('Copy generated URL'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // TODO I can barely see the image; it's so small
                    ///title: Text(cachedImageWorkName),
                    ///trailing: CachedNetworkImage(
                    ///  imageUrl: bapiGeneratedUrl(host, cachedImageWorkName),
                    ///  progressIndicatorBuilder: (context, url, progress) =>
                    ///      CircularProgressIndicator(value: progress.progress),
                    ///  errorWidget: (context, url, error) {
                    ///    // TODO on-click, refresh to re-query server
                    ///    return const Icon(Icons.error);
                    ///  },
                    ///),
                    //trailing: true //workIDStatuses.containsKey(workID)
                    //    ? Text(workIDStatuses[workID]!)
                    //    : IconButton(
                    //        icon: const Icon(Icons.refresh),
                    //        onPressed: () => updateWorkIDStatus(workID),
                    //      ),
                    onTap: () async {
                      // TODO clicking on any work will bring up a little menu
                      //  button to save the completed work to disk
                      //  button to copy work file name
                      //  button to copy /generated url for work file
                      // a GestureDetector to the side that refreshes

                      // some kind of pop-up
                      //

                      //if (workIDStatuses.containsKey(workID) &&
                      //    workIDStatuses[workID] == 'Finished') {
                      //  // Show cached result
                      //  showDialog(
                      //    context: context,
                      //    builder: (context) => AlertDialog(
                      //      title: const Text('Cached Result'),
                      //      content: Text('This is the cached result for $workID'),
                      //    ),
                      //  );
                      //} else {
                      //  // Query server for status
                      //  updateWorkIDStatus(workID);
                      //}
                    },
                  );
                }).toList(),
              ),

              // garbo...
              /*
              child: ListView.builder(
                itemCount: cachedWorkIDList.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final cachedWorkID = cachedWorkIDList[index];
                  final host = prefs.get<String>(apiHostPrefKey)!;
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //const Spacer(),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: bapiGeneratedUrl(host, cachedWorkID),
                              progressIndicatorBuilder: (context, url, progress) =>
                                  CircularProgressIndicator(value: progress.progress),
                              errorWidget: (context, url, error) {
                                // TODO on-click, refresh to re-query server
                                return const Icon(Icons.error);
                              },
                            ),
                            //child: Image.file(
                            //  File(path),
                            //  width: 100,
                            //),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            cachedWorkID, //cachedImageWorkName.limit(40),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        PopupMenuButton<WorkPopupItems>(
                          initialValue: selectedItem,
                          onSelected: (WorkPopupItems item) async {
                            switch (item) {
                              // TODO grey-out menu item if work is not completed
                              case WorkPopupItems.save:
                                // trigger save?
    
                                // for now user can just copy url regardless
                              case WorkPopupItems.copyFileName:
                                await Clipboard.setData(
                                  ClipboardData(
                                    text: cachedWorkID, // bapiGeneratedUrl(host, cachedImageWorkName),
                                  ),
                                );
                                Fluttertoast.showToast(msg: 'Copied filename');
                                log('clicked on queued work');
                              case WorkPopupItems.copyUrl:
                                await Clipboard.setData(
                                  ClipboardData(
                                    text: bapiGeneratedUrl(host, cachedWorkID),
                                  ),
                                );
                                Fluttertoast.showToast(msg: 'Copied generated url');
                                log('clicked on queued work');
                            }
                            setState(() {
                              selectedItem = item;
                            });
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<WorkPopupItems>>[
                            const PopupMenuItem<WorkPopupItems>(
                              value: WorkPopupItems.save,
                              child: Text('Save (NYI)'),
                            ),
                            const PopupMenuItem<WorkPopupItems>(
                              value: WorkPopupItems.copyFileName,
                              child: Text('Copy file name'),
                            ),
                            const PopupMenuItem<WorkPopupItems>(
                              value: WorkPopupItems.copyUrl,
                              child: Text('Copy generated URL'),
                            ),
                          ],
                        )
                      ]
                    ),
                    // TODO I can barely see the image; it's so small
                    ///title: Text(cachedImageWorkName),
                    ///trailing: CachedNetworkImage(
                    ///  imageUrl: bapiGeneratedUrl(host, cachedImageWorkName),
                    ///  progressIndicatorBuilder: (context, url, progress) =>
                    ///      CircularProgressIndicator(value: progress.progress),
                    ///  errorWidget: (context, url, error) {
                    ///    // TODO on-click, refresh to re-query server
                    ///    return const Icon(Icons.error);
                    ///  },
                    ///),
                    //trailing: true //workIDStatuses.containsKey(workID)
                    //    ? Text(workIDStatuses[workID]!)
                    //    : IconButton(
                    //        icon: const Icon(Icons.refresh),
                    //        onPressed: () => updateWorkIDStatus(workID),
                    //      ),
                    onTap: () async {
                      // TODO clicking on any work will bring up a little menu
                      //  button to save the completed work to disk
                      //  button to copy work file name
                      //  button to copy /generated url for work file
                      // a GestureDetector to the side that refreshes
    
                      // some kind of pop-up
                      // 
                      
    
                      //if (workIDStatuses.containsKey(workID) &&
                      //    workIDStatuses[workID] == 'Finished') {
                      //  // Show cached result
                      //  showDialog(
                      //    context: context,
                      //    builder: (context) => AlertDialog(
                      //      title: const Text('Cached Result'),
                      //      content: Text('This is the cached result for $workID'),
                      //    ),
                      //  );
                      //} else {
                      //  // Query server for status
                      //  updateWorkIDStatus(workID);
                      //}
                    },
                  );
                },
              ),
              */
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            heroTag: 'work-clear-fab',
            onPressed: () {
              prefs.set(apiCachedWorkIDListPrefKey, <String>[]);
              setState(() {
                // reset
                //this menu page should be stateless?
              });
            },
            //foregroundColor: customizations[index].$1,
            //backgroundColor: customizations[index].$2,
            //shape: customizations[index].$3,
            child: Icon(MdiIcons.trashCan),
          ),
          // Navigator.of(context).popUntil((route) => route.isFirst);
          FloatingActionButton(
            heroTag: 'work-refresh-fab',
            onPressed: () {
              setState(() {
                //this menu page should be stateless?
              });
            },
            //foregroundColor: customizations[index].$1,
            //backgroundColor: customizations[index].$2,
            //shape: customizations[index].$3,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
