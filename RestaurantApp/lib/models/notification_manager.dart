import 'package:flutter/foundation.dart';
import 'dart:io';

//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationManager extends ChangeNotifier {
  String uid;

  void setup(String userUid) {
    uid = userUid;

    final FirebaseMessaging _fcm = FirebaseMessaging();

    FirebaseMessaging().configure(
      onMessage: (Map<String, dynamic> incomingMessage) async {
        print('onMessage');
      },
    );

    if (Platform.isIOS) {
      _fcm.onIosSettingsRegistered.listen((data) {
        saveDeviceToken();
      });
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(),
      );
    } else {
      saveDeviceToken();
    }
  }

  void saveDeviceToken() async {
    final FirebaseMessaging _fcm = FirebaseMessaging();

    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokenRef = Firestore.instance
          .collection('restaurants')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokenRef.setData({
        'token': fcmToken,
        'platform': Platform.operatingSystem,
      });
    }
  }
}
