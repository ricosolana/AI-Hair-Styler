import 'dart:convert';

import 'package:senior_project_hair_ai/preferences_provider.dart';

const String activeProfileUserIDPrefKey = 'active-profile-user-id';
const String jsonUserProfilesPrefKey = 'json-user-profiles';

class UserManager {
  //UserProfile({required this.userID, required this.displayName});

  static String getAbbreviation(String s) {
    return s.split(' ').map((e) => e[0]).join().toUpperCase();
  }



  static Map<String, String> users = {};

  // TODO should save each time a modification is made
  static void load() {
    final json = jsonDecode(prefs.ensure<String>(jsonUserProfilesPrefKey)) as Map<String, dynamic>;
    users = json.map((key, value) => MapEntry(key, value as String));
  }

  static void save() {
    prefs.set(jsonUserProfilesPrefKey, jsonEncode(users));
  }

  static String? getUserDisplayName(String userID) {
    return users[userID];
  }

  // returns whether successful (collision or not)
  static bool createUser(String userID, String displayName) {
    var dup = true;
    users.putIfAbsent(userID, () {
      dup = false;
      return displayName;
    });
    if (!dup) {
      save(); // persistence
    }
    return !dup;
  }
}