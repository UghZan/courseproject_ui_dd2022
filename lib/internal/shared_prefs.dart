import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/user.dart';

class SharedPrefs {
  static const String _userKey = "_kUserKey";

  static Future<User?> getStoredUser() async {
    var sp = await SharedPreferences.getInstance();
    var userJson = sp.getString(_userKey);
    return (userJson == "" || userJson == null)
        ? null
        : User.fromJson(jsonDecode(userJson));
  }

  static Future setStoredUser(User? user) async {
    var sp = await SharedPreferences.getInstance();
    if (user == null) {
      sp.remove((_userKey));
    } else {
      await sp.setString(_userKey, jsonEncode(user.toJson()));
    }
  }
}
