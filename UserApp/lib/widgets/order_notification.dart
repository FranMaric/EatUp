import 'package:EatUpUserApp/constants.dart';
import 'package:EatUpUserApp/models/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> message =
        Provider.of<NotificationManager>(context, listen: false).message;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.2),
      padding: EdgeInsets.symmetric(horizontal: 15),
      //
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(
          color: kAccentColor,
          width: 1,
        ),
      ),
      //
      child: ListTile(
        title: Text(
          message['notification']['title'],
        ),
        subtitle: Text(
          ['', ' ', null].contains(message['notification']['body'])
              ? 'Nema poruke restorana.'
              : ('Poruka restorana: ' + message['notification']['body']),
        ),
      ),
    );
  }
}
