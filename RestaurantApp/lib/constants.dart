import 'package:flutter/material.dart';

//Colors
final Color kBackgroundColor = Colors.grey[300];
const Color kAccentColor = Color(0xffFF6D00);

//Dimensions
const double kSearchBarHeight = 50.0;
const double kSearchBarRadius = 30.0;

const double kInputHeight = 50.0;

const TextStyle titleStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w600,
);

const TextStyle subtitleStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
);

String tryInt(number) {
  if (number is double && number.round() == number) {
    return number.round().toString();
  }
  return number.toString();
}
