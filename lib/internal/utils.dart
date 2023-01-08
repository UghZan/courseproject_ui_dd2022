import 'package:courseproject_ui_dd2022/internal/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../domain/models/user.dart';

extension StringExtension on String {
  void console() {
    if (kDebugMode) {
      print(this);
    }
  }
}

class Utils {
  static ImageProvider<Object>? getAvatar(User? user) {
    if (user == null) return null;
    if (user.linkToAvatar?.isNotEmpty ?? false) {
      return NetworkImage("$baseUrl${user.linkToAvatar}");
    } else {
      return const AssetImage("images/no_avatar.png");
    }
  }
}
