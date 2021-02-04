import 'package:EatUpUserApp/constants.dart';
import 'package:flutter/material.dart';

class BannedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                'Ovom uređaju je zabranjeno korištenje aplikacije zbog izrabljivanja usluge!\nAko smatrate da smo pogrješili kontaktirajte nas kako bismo popravili problem.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
