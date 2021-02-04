import 'package:flutter/material.dart';

class ChangeActivityAlertDialog extends StatelessWidget {
  final bool opening;

  ChangeActivityAlertDialog({this.opening});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Upozorenje'),
      content: Text(
        (!opening
                ? 'Ako zatvorite restoran nećete moći zaprimati narudžbe!\n\n'
                : '') +
            'Jeste li sigurni da želite ${opening ? 'otvoriti' : 'zatvoriti'} restoran?',
      ),
      actions: [
        FlatButton(
          child: Text(
            "Odustani",
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        RaisedButton(
          child: Text(
            opening ? 'OTVORI' : 'ZATVORI',
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
