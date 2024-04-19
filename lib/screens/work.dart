import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';
import 'package:url_launcher/url_launcher.dart';

enum WorkPopupItems {
  save,
  copyFileName,
  copyUrl,
  openUrl
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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final Tween<Offset> _tween = Tween(
      begin: const Offset(1, 0),
      end: Offset.zero
  );
  //late List<WorkItemModel> _refreshNotifiers;
  //late StreamController<TaskProgress> _controller;
  //late Timer _timer;

  late PreferencesProvider prefs;
  late List<String> cachedWorkIDList;

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

    prefs = Provider.of<PreferencesProvider>(context, listen: false);
    cachedWorkIDList = prefs.get<List<String>>(apiCachedWorkIDListPrefKey)!;

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
    final host = prefs.get<String>(apiHostPrefKey)!;

    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Work Queue"),
      ),
      body: Center(
        child: cachedWorkIDList.isEmpty
            ? const Text('Hmm, no work.') :
        Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: Colors.white,
                backgroundColor: Colors.blue,
                onRefresh: () async {
                  // Replace this delay with the code to be executed during refresh
                  // and return asynchronous code
                  //return Future<void>.delayed(const Duration(seconds: 3));
                  // TODO refresh, l
                  setState(() {});
                },
                // This check is used to customize listening to scroll notifications
                // from the widget's children.
                //
                // By default this is set to `notification.depth == 0`, which ensures
                // the only the scroll notifications from the first scroll view are listened to.
                //
                // Here setting `notification.depth == 1` triggers the refresh indicator
                // when overscrolling the nested scroll view.
                notificationPredicate: (ScrollNotification notification) {
                  return notification.depth == 0;
                },
                // TODO use ListView.builder
                child: AnimatedList(
                  key: _listKey,
                  physics: const AlwaysScrollableScrollPhysics(),
                  initialItemCount: cachedWorkIDList.length,
                  itemBuilder: (context, index, animation) {
                    // We want to render the list backwards,
                    //  so the new items appear first
                    final reverseIndex = cachedWorkIDList.length - index - 1;
                    //index = cachedWorkIDList.length - index;
                    //final workID = cachedWorkIDList[cachedWorkIDList.length - index - 1];
                    final workID = cachedWorkIDList[reverseIndex];
                    return SlideTransition(
                      position: _tween.animate(animation),
                      child: Dismissible(
                        //key: Key(workID),
                        key: UniqueKey(),
                        // Accept
                        background: const ColoredBox(
                          color: Colors.green,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Icon(Icons.save),
                            ),
                          ),
                        ),
                        secondaryBackground: const ColoredBox(
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(Icons.delete),
                            ),
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          // In this case, swiping any direction will dismiss element
                          //bool delete = true;

                          if (direction == DismissDirection.startToEnd) {
                            // TODO send image to gallery
                          } else {
                            ScaffoldMessenger.of(context).removeCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Deleted $workID'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      _tween.begin = Offset(direction == DismissDirection.startToEnd ? 1 : -1, 0);

                                      cachedWorkIDList.insert(reverseIndex, workID);
                                      prefs.set(apiCachedWorkIDListPrefKey, cachedWorkIDList);
                                      _listKey.currentState?.insertItem(index);
                                      //cachedWorkIDList.insert(cachedWorkIDList.length - index, workID);
                                    });
                                  }
                                ),
                              ),
                            );
                          }
                          //return delete;
                          return true;
                        },
                        onDismissed: (_) {
                          setState(() {
                            cachedWorkIDList.removeAt(reverseIndex);
                            //cachedWorkIDList.remove(workID);
                            prefs.set(apiCachedWorkIDListPrefKey, cachedWorkIDList);
                            _listKey.currentState?.removeItem(index, (context, animation) => Container());
                          });
                        },
                        child: SizeTransition(
                          sizeFactor: animation,
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //const Spacer(),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: CachedNetworkImage(
                                      imageUrl: bapiGeneratedUrl(host, workID).toString(),
                                      memCacheWidth: (100 * devicePixelRatio).round(),
                                      progressIndicatorBuilder:
                                          (context, url, progress) =>
                                              CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                      errorListener: (obj) {
                                        log(obj.toString());
                                      },
                                      errorWidget: (context, url, error) {
                                        // TODO show status/progress
                                        return StreamBuilder<TaskProgress>(
                                          stream: fetchJobStatusPeriodically(workID),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              // somewhat unexpected for the API to not respond
                                              return Icon(MdiIcons.serverOff);
                                            } else {
                                              final progress = snapshot.data!;
                                              return Stack(
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  if (progress
                                                          .currentTransformerPercentage !=
                                                      null)
                                                    TweenAnimationBuilder<double>(
                                                      // TODO check if tween bounds require [0,1]
                                                      //tween: Tween<double>(begin: 0, end: progress.),
                                                      tween: Tween<double>(
                                                          begin: 0,
                                                          end: progress
                                                                  .currentTransformerPercentage!
                                                                  .toDouble() /
                                                              100.0,),
                                                      // TODO test
                                                      duration:
                                                          const Duration(seconds: 1),
                                                      builder: (BuildContext context,
                                                          double tweenValue,
                                                          Widget? child,) {
                                                        return CircularProgressIndicator(
                                                          value: tweenValue,
                                                          strokeWidth: 10,
                                                        );
                                                      },
                                                      child: const Icon(
                                                          Icons.aspect_ratio,),
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
                                          bapiGeneratedUrl(host, workID).toString(),
                                        );

                                        if (file != null) {
                                          final params = SaveFileDialogParams(
                                            sourceFilePath: file.file.path,
                                            fileName: workID +
                                                path.extension(file.file.basename),
                                          );
                                          final filePath =
                                              await FlutterFileDialog.saveFile(
                                            params: params,
                                          );

                                          if (filePath != null) {
                                            Fluttertoast.showToast(
                                              msg: 'Saved to directory $filePath',
                                              toastLength: Toast.LENGTH_LONG,
                                            );
                                          }
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
                                            text: bapiGeneratedUrl(host, workID).toString(),
                                          ),
                                        );
                                        Fluttertoast.showToast(
                                          msg: 'Copied generated url',
                                        );
                                      case WorkPopupItems.openUrl:
                                        if (!await launchUrl(bapiGeneratedUrl(host, workID))) {
                                          Fluttertoast.showToast(
                                            msg: 'Unable to open URL',
                                          );
                                        }

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
                                    const PopupMenuItem<WorkPopupItems>(
                                      value: WorkPopupItems.openUrl,
                                      child: Text('Open in browser'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () async {
                              // TODO what should be do on click?
                              //    show a larger image?
                            },
                          ),
                        ),
                      ),
                    );
                  })
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0), // Adjust the padding as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end, // Aligns the FABs to the right
          children: [
            FloatingActionButton(
              heroTag: 'work-clear-fab',
              onPressed: () {
                // first prompt
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Clear queue'),
                        content: const Text(
                            'Are you sure you want to clear the work queue? This action is irreversible.'
                        ),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Clear all'),
                            onPressed: () {
                              prefs.set(apiCachedWorkIDListPrefKey, <String>[]);
                              setState(() {});
                              Navigator.of(context).pop();
                              Fluttertoast.showToast(msg: 'Cleared work queue');
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                );
              },
              child: Icon(MdiIcons.trashCan),
            ),
            const SizedBox(width: 10), // Adds some space between the FABs
            FloatingActionButton(
              heroTag: 'work-refresh-fab',
              onPressed: () {
                setState(() {
                  //this menu page should be stateless?
                });
              },
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
