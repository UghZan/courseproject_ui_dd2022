import 'package:courseproject_ui_dd2022/internal/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../data/service/database.dart';
import '../ui/navigation/app_navigator.dart';
import 'firebase_options.dart';

void showModal(
  String title,
  String content,
) {
  var ctx = AppNavigator.key.currentContext;
  if (ctx != null) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"))
          ],
        );
      },
    );
  }
}

Future initFireBase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  FirebaseMessaging.onMessage.listen(catchMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(catchMessage);
  try {
    ("Token: ${(await messaging.getToken()) ?? "no token"}").console();
  } catch (e) {
    (e.toString()).console();
  }
}

Future initApp() async {
  await initFireBase();
  await DB.instance.init();
}

void catchMessage(RemoteMessage message) {
  ('Message data: ${message.data}').console();
  if (message.notification != null) {
    showModal(
        message.notification!.title ?? "", message.notification!.body ?? "");
    ('Message notification: ${message.notification!.body}').console();
  }
}
