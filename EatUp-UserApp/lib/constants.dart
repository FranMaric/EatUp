import 'package:flutter/material.dart';

const int newOrderAfter = 600000; //Ten minutes in milliseconds

//Colors
const Color kBackgroundColor = Color(0xFFe0e0e0);
const Color kAccentColor = Color(0xffFF6D00);

//Dimensions
const double kSearchBarHeight = 50.0;
const double kSearchBarRadius = 30.0;

const double kRestaurantTileHeight = 150.0;

const double kInputHeight = 50.0;

//Shadow constant
final List<BoxShadow> shadows = [
  BoxShadow(
    color: Colors.grey[500],
    offset: Offset(2.0, 2.0),
    blurRadius: 15.0,
    spreadRadius: 1.0,
  ),
  BoxShadow(
    color: Colors.white,
    offset: Offset(-2.0, -2.0),
    blurRadius: 15.0,
    spreadRadius: 1.0,
  ),
];

List<String> supportedPhoneCodes = [
  '+385',
  '+381',
  '+387',
  '+49',
];

List<String> supportedImages = [
  'appetizers',
  'burger',
  'desert',
  'fish',
  'fires',
  'grill',
  'pasta',
  'pizza',
  'salad',
  'sandwich',
  'soup'
];

bool validAddres(
    {String street, String houseNumber, String surname, String area}) {
  return street.length >= 3 &&
      surname.length >= 2 &&
      houseNumber.contains(new RegExp(r'[0-9]')) &&
      area.length >= 3;
}
