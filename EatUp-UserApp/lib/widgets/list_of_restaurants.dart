import 'package:EatUpUserApp/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';

//Widget
import 'package:EatUpUserApp/widgets/restaurant_tile.dart';

//Screens
import 'package:EatUpUserApp/screens/loading_indicator.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:EatUpUserApp/services/database.dart';

class ListOfRestaurants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<Data>(context).restaurants != null) {
      return ListView.builder(
        itemCount: Provider.of<Data>(context).restaurants.length,
        itemBuilder: (BuildContext context, int index) => RestaurantTile(
          restaurant: Provider.of<Data>(context).restaurants[index],
          index: index,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RestaurantScreen(
                  index: index,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return LoadingIndicator();
    }
  }
}
