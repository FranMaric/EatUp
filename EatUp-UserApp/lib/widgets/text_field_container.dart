import 'package:flutter/material.dart';
import 'package:EatUpUserApp/constants.dart';

class MyTextField extends StatelessWidget {
  final String title;
  final TextInputType keyboardType;
  final Function onChanged;
  final double horizMargin;
  final TextEditingController controller;
  final int maxLines;

  MyTextField({
    this.title,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.horizMargin = 20.0,
    this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizMargin,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        boxShadow: shadows,
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: TextField(
        maxLines: maxLines,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          focusColor: Colors.black,
          labelText: title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
