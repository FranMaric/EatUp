import 'package:EatUpUserApp/constants.dart';
import 'package:EatUpUserApp/models/restaurant_object.dart';
import 'package:EatUpUserApp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:transparent_image/transparent_image.dart';

class RestaurantTile extends StatelessWidget {
  final Function onTap;

  final Restaurant restaurant;
  final int index;

  RestaurantTile({
    this.onTap,
    this.restaurant,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kRestaurantTileHeight,
        width: double.infinity,
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0)),
          boxShadow: shadows,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 4.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.memory(
                Provider.of<Data>(context).restaurants[index].image ??
                    kTransparentImage,
                width: kRestaurantTileHeight * 0.8,
                height: kRestaurantTileHeight * 0.8,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: ListTile(
                  title: Text(
                    restaurant.name ?? 'Nema naslova',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    restaurant.description ?? 'Nema opsia',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
