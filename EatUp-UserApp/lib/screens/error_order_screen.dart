import 'package:EatUpUserApp/models/order_object.dart';
import 'package:EatUpUserApp/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:EatUpUserApp/constants.dart';

//Screen
import 'package:EatUpUserApp/screens/main_screen.dart';

//Widget
import 'package:EatUpUserApp/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class ErrorOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: EatUpLogo(),
        backgroundColor: kAccentColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Došlo je do pogreške.\nProvjerite internet ili ako ste već napravili narudžbu u posljednjih deset minuta onda se strpite za novu narudžbu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RoundedButton(
            onTap: () {
              Provider.of<Order>(context, listen: false).reset();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            },
            backgroundColor: kAccentColor,
            title: 'IZBORNIK',
          ),
        ],
      ),
    );
  }
}
