import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager extends ChangeNotifier {
  bool notify;

  Map<String, dynamic> message;

  String uid;

  void setup(String userUid) {
    uid = userUid;

    final FirebaseMessaging _fcm = FirebaseMessaging();

    FirebaseMessaging().configure(
      onMessage: (Map<String, dynamic> incomingMessage) async {
        notify = true;
        message = incomingMessage;

        notifyListeners();
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
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokenRef.setData({
        'token': fcmToken,
        'platform': Platform.operatingSystem,
      });
    }
  }

  void removeNotification() {
    notify = false;
    notifyListeners();
  }
}
