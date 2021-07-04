import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tenisleague100/services/GlobalValues.dart';
import 'package:http/http.dart' as http;
import 'package:tenisleague100/models/ModelNotification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenisleague100/services/shared_preferences_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class FirebaseNotifications {
  static BuildContext myContext;
  static String _token;
  static String firebaseKey = GlobalValues.firebaseKey;
  static String currentUserId ;

  static void setUp(BuildContext context) async {
    final sp = context.read<SharedPreferencesService>(sharedPreferencesServiceProvider);
    currentUserId = await sp.getCurrentUSerId();
    myContext = context;
    getToken();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.subscribeToTopic(currentUserId);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        Fluttertoast.showToast(
            msg: notification.body,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(GlobalValues.mainGreen),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  static void getToken() {
    FirebaseMessaging.instance.getToken().then((value) => _token = value);
  }

  /// Define a top-level named handler which background/terminated messages will
  /// call.
  ///
  /// To verify things are working, check out the native platform logs.
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  //https://stackoverflow.com/questions/37482366/is-it-safe-to-expose-firebase-apikey-to-the-public
  static void sendPushMessage(ModelNotification notification) async {
    await http
        .post('https://fcm.googleapis.com/fcm/send',
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=$firebaseKey'
            },
            body: jsonEncode({
              'notification': <String, dynamic>{'title': notification.title, 'body': notification.body, 'sound': 'true'},
              'priority': 'high',
              'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done'},
              "to": "/topics/" + notification.topic
            }))
        .whenComplete(() {
    }).catchError((e) {
      print('sendOrderCollected() error: $e');
    });
  }

  static void unSubscribe()async{
    await FirebaseMessaging.instance.unsubscribeFromTopic(currentUserId);
  }
}
