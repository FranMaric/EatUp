import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:EatUpRestaurantApp/services/database.dart';
import 'package:EatUpRestaurantApp/models/notification_manager.dart';

//Auth
import 'package:EatUpRestaurantApp/services/authservice.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Data()),
        ChangeNotifierProvider(
          create: (_) => NotificationManager(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthService().handleAuth(),
      ),
    );
  }
}
