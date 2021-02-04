import 'package:flutter/material.dart';

class AcceptAlertDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Želite li dati poruku naručitelju?',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                )),
            child: TextField(
              maxLines: 3,
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Dolazi za xy min.',
              ),
            ),
          )
        ],
      ),
      buttonPadding: EdgeInsets.all(10.0),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'Odustani',
            style: TextStyle(color: Colors.blue[300]),
          ),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop([true, _controller.text]);
          },
          child: Text('PRIHVATI'),
        ),
      ],
      elevation: 20.0,
    );
  }
}
