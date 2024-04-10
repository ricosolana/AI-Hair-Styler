import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/api_access.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';

// TODO
//  this class will render the queued work and awaiting tasks being processed on the server
//

const String apiCachedWorkListPrefKey = 'api-cached-work-list';

class MyQueuedWorkPage extends StatefulWidget {
  @override
  _MyQueuedWorkPageState createState() => _MyQueuedWorkPageState();
}

class _MyQueuedWorkPageState extends State<MyQueuedWorkPage> {
  //List<String> workIDs = [];
  //Map<String, String> workIDStatuses = {};

  @override
  void initState() {
    super.initState();
    //fetchWorkIDs();
  }

  //Future<void> fetchWorkIDs() async {
  //  final response = await http.get(Uri.parse('YOUR_SERVER_URL_HERE'));
  //  if (response.statusCode == 200) {
  //    setState(() {
  //      //workIDs = List<String>.from(jsonDecode(response.body));
  //    });
  //  } else {
  //    throw Exception('Failed to load work IDs');
  //  }
  //}

  /*
  Future<void> updateWorkIDStatus(String workID) async {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);

    bapiGeneratedUrl(prefs.get(apiHostPrefKey)!, workID);

    final response = await http.get(Uri.parse('YOUR_SERVER_URL_HERE/$workID'));

    if (response.statusCode == 200) {
      setState(() {
        //workIDStatuses[workID] = jsonDecode(response.body)['status'];
        workIDStatuses[workID] = 'Success?';
      });
    } else if (response.statusCode == 404) {
      // likely not ready yet
    } else {
      throw Exception('Failed to update work ID status');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);
    final cachedWorkList = prefs.get<List<String>>(apiCachedWorkListPrefKey)!;

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
              child: ListView.builder(
                itemCount: cachedWorkList.length,
                itemBuilder: (context, index) {
                  final cachedImageWorkName = cachedWorkList[index];
                  final host = prefs.get<String>(apiHostPrefKey)!;
                  return ListTile(
                    title: Text(cachedImageWorkName),
                    trailing: CachedNetworkImage(
                        imageUrl: bapiGeneratedUrl(host, cachedImageWorkName),
                        progressIndicatorBuilder: (context, url, progress) =>
                            CircularProgressIndicator(value: progress.progress),
                        errorWidget: (context, url, error) {
                          // TODO on-click, refresh to re-query server
                          return const Icon(Icons.error);
                        },),
                    //trailing: true //workIDStatuses.containsKey(workID)
                    //    ? Text(workIDStatuses[workID]!)
                    //    : IconButton(
                    //        icon: const Icon(Icons.refresh),
                    //        onPressed: () => updateWorkIDStatus(workID),
                    //      ),
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(
                          text: bapiGeneratedUrl(host, cachedImageWorkName),),);
                      Fluttertoast.showToast(msg: 'Copied url');
                      log('clicked on queued work');
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
            ),
          ],
        ),
      ),
    );
  }
}
