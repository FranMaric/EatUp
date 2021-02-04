import 'package:EatUpUserApp/screens/main_screen.dart';
import 'package:EatUpUserApp/widgets/logo.dart';
import 'package:EatUpUserApp/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:EatUpUserApp/constants.dart';

class SuccesfulOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: EatUpLogo(),
        backgroundColor: kAccentColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Vaša narudžba je poslana u restoran.\nPričekajte da potvrde vašu narudžbu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RoundedButton(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
              );
            },
            backgroundColor: kAccentColor,
            title: 'NAZAD',
          ),
        ],
      ),
    );
  }
}
