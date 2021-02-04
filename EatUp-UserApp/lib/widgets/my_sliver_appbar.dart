import 'package:flutter/material.dart';

import 'package:EatUpUserApp/constants.dart';

class MySliverAppBar extends StatelessWidget {
  final String title;
  final ImageProvider image;

  MySliverAppBar({
    this.title,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width * 0.6,
      pinned: true,
      floating: false,
      backgroundColor: kAccentColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(
              right: 15,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: kAccentColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Text(
                title,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
