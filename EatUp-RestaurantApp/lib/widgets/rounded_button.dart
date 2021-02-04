import 'package:flutter/material.dart';
import 'package:EatUpRestaurantApp/constants.dart';

class RoundedButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  final Color color;
  final double horizMargin;

  RoundedButton({
    this.title,
    this.onTap,
    this.backgroundColor = kAccentColor,
    this.titleColor = Colors.white,
    this.horizMargin = 5.0,
    this.color = kAccentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: horizMargin,
          vertical: 5.0,
        ),
        height: kInputHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
        ),
      ),
    );
  }
}
