import 'package:EatUpUserApp/screens/order_screen.dart';
import 'package:flutter/material.dart';

import 'package:EatUpUserApp/constants.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:EatUpUserApp/models/order_object.dart';

class OrderTab extends StatelessWidget {
  final bool active;

  OrderTab({this.active});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (active) {
          if (Provider.of<Order>(context, listen: false).meals.length == 0) {
            showDialog(
              context: context,
              builder: (context) => NoOrderAlert(),
            );
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrderScreen(),
            ));
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: active == true ? kAccentColor : Colors.grey[500],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10),
            Text(
              active == true ? 'Narudžba:' : 'ZATVORENO',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20.0,
                letterSpacing: 1.0,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_upward,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(width: 20)
          ],
        ),
      ),
    );
  }
}

class NoOrderAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Narudžba vam je prazna',
      ),
      content: Text(
        'Prvo odaberite barem jedno jelo',
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      buttonPadding: EdgeInsets.all(10.0),
      elevation: 20.0,
    );
  }
}
