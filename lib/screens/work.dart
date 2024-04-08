import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// TODO
//  this class will render the queued work and awaiting tasks being processed on the server
//

class WorkIDList extends StatefulWidget {
  @override
  _WorkIDListState createState() => _WorkIDListState();
}

class _WorkIDListState extends State<WorkIDList> {
  List<String> workIDs = [];
  Map<String, String> workIDStatuses = {};

  @override
  void initState() {
    super.initState();
    fetchWorkIDs();
  }

  Future<void> fetchWorkIDs() async {
    final response = await http.get(Uri.parse('YOUR_SERVER_URL_HERE'));

    if (response.statusCode == 200) {
      setState(() {
        //workIDs = List<String>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Failed to load work IDs');
    }
  }

  Future<void> updateWorkIDStatus(String workID) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workIDs.length,
      itemBuilder: (context, index) {
        final workID = workIDs[index];
        return ListTile(
          title: Text(workID),
          trailing: workIDStatuses.containsKey(workID)
              ? Text(workIDStatuses[workID]!)
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => updateWorkIDStatus(workID),
                ),
          onTap: () {
            if (workIDStatuses.containsKey(workID) &&
                workIDStatuses[workID] == 'Finished') {
              // Show cached result
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cached Result'),
                  content: Text('This is the cached result for $workID'),
                ),
              );
            } else {
              // Query server for status
              updateWorkIDStatus(workID);
            }
          },
        );
      },
    );
  }
}
