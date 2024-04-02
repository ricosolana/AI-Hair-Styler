import 'package:flutter/foundation.dart';

class RecentsProvider with ChangeNotifier {
  final List<String> _savedFiles = [];

  List<String> get savedFiles => _savedFiles;

  void addFile(String filePath) {
    _savedFiles.add(filePath);
    notifyListeners();
  }
}
