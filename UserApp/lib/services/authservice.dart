import 'package:EatUpUserApp/models/notification_manager.dart';
import 'package:flutter/material.dart';

//Screens
import 'package:EatUpUserApp/screens/login_screen.dart';
import 'package:EatUpUserApp/screens/main_screen.dart';
import 'package:EatUpUserApp/screens/first_time_login_screen.dart';
import 'package:EatUpUserApp/screens/loading_indicator.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:EatUpUserApp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //Handles Auth
  Widget handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<Data>(context, listen: false).saveUser(snapshot.data);

          Provider.of<NotificationManager>(context, listen: false)
              .setup(snapshot.data.uid);

          return FutureBuilder(
            future: Provider.of<Data>(context, listen: false)
                .checkIfNewUser(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == true) {
                  return FirstTimeLoginScreen();
                } else {
                  return MainScreen();
                }
              }
              return LoadingIndicator();
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        } else
          return LoginScreen();
      },
    );
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  signInWithSmsCode(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
}
