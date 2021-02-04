import 'package:EatUpUserApp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AreaPicker extends StatefulWidget {
  final Function onChange;

  AreaPicker({this.onChange});

  @override
  _AreaPickerState createState() => _AreaPickerState();
}

class _AreaPickerState extends State<AreaPicker> {
  String _currentValue = 'Vinkovci';
  List<String> areas = [];

  @override
  void initState() {
    super.initState();
    getAreas();
  }

  void getAreas() async {
    DocumentSnapshot areasResponse =
        await Firestore.instance.collection('areas').document('areas').get();
    setState(() {
      areas = List<String>.from(areasResponse.data['list']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        underline: SizedBox(),
        iconSize: 42,
        value: _currentValue,
        items: areas
            .map(
              (area) => DropdownMenuItem(
                value: area,
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  child: Text(area),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          widget.onChange(value);

          setState(() {
            _currentValue = value;
          });
        },
      ),
    );
  }
}
