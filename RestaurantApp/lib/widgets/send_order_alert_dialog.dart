import 'package:flutter/material.dart';

class SendOrderAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Jeste li sigurni da je ova narudžba gotova?'),
      content: Text('Želite ju poslati?'),
      actions: [
        FlatButton(
          child: Text('NE'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        RaisedButton(
          child: Text('DA'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
