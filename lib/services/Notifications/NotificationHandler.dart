/*
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  static BuildContext myContext;
  static void initNotification(BuildContext context) {
    myContext = context;
    var initAndroid = AndroidInitializationSettings("@mimap/ic_launcher");
    var initSetting = InitializationSettings(android: initAndroid);
    flutterLocalNotificationPlugin.initialize(initSetting, onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String payload) async {
    if (payload != null) {
      print("notification payload: " + payload);
    }
  }
}
*/
