import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/services/Notifications/NotificationHandler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class FirebaseNotifications {
  static BuildContext myContext;
  static String _token;

  static void setUp(BuildContext context) async {
    myContext = context;
    getToken();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.subscribeToTopic('fcm_test');

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message received");
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

/*    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage?.data['type'] == 'chat') {
      Navigator.pushNamed(context, '/chat',
          arguments: ChatArguments(initialMessage));
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'chat') {
        Navigator.pushNamed(context, '/chat',
            arguments: ChatArguments(message));
      }
    });*/
  }

  static Future<void> getToken() {
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

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String constructFCMPayload(String token, String message) {
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': message,
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$message) was created via FCM!',
      },
    });
  }

/*  Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }*/

}
