import 'package:flutter/material.dart';

class AddressDeleteAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Brisanje adrese"),
      content: Text("Jeste li sigurni da želite obrisati adresu?"),
      actions: [
        FlatButton(
          child: Text(
            "Odustani",
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FlatButton(
          child: Text(
            "Obriši",
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
