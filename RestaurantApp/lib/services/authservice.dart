import 'package:EatUpRestaurantApp/models/notification_manager.dart';
import 'package:flutter/material.dart';

//Screens
import 'package:EatUpRestaurantApp/screens/login_screen.dart';
import 'package:EatUpRestaurantApp/screens/main_screen.dart';
import 'package:EatUpRestaurantApp/screens/loading_indicator.dart';

//Provider
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:EatUpRestaurantApp/services/database.dart';

class AuthService {
  //Handles Auth
  Widget handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<Data>(context, listen: false).uid = snapshot.data.uid;
          Provider.of<NotificationManager>(context, listen: false)
              .setup(snapshot.data.uid);

          return FutureBuilder(
            future: Provider.of<Data>(context, listen: false).setup(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return MainScreen();
              }
              return LoadingIndicator();
            },
          );
        } else if (snapshot.hasError) {
          return LoadingIndicator();
        }
        return LoginScreen();
      },
    );
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //Sign in with email
  signInWithEmail(email, pass) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);
  }
}
