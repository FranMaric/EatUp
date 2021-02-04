import 'package:flutter/material.dart';

//Objects
import 'package:EatUpUserApp/models/restaurant_object.dart';
import 'package:EatUpUserApp/models/order_object.dart';

//Widgets
import 'package:EatUpUserApp/widgets/menu_item_widget.dart';
import 'package:EatUpUserApp/widgets/my_sliver_appbar.dart';
import 'package:EatUpUserApp/widgets/order_tab.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:EatUpUserApp/services/database.dart';

import 'package:EatUpUserApp/constants.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantScreen extends StatelessWidget {
  final int index;

  RestaurantScreen({this.index});

  @override
  Widget build(BuildContext context) {
    Restaurant restaurant = Provider.of<Data>(context).restaurants[index];

    Provider.of<Order>(context, listen: false).restaurantUid = restaurant.uid;
    Provider.of<Order>(context, listen: false).restaurantName = restaurant.name;

    return WillPopScope(
      onWillPop: () async {
        if (Provider.of<Order>(context, listen: false).meals.length == 0) {
          return true;
        } else {
          bool leave = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => MyAlertDialog(),
          );
          if (leave) {
            Provider.of<Order>(context, listen: false).reset();
          }
          return leave;
        }
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  MySliverAppBar(
                    title: restaurant.name,
                    image: MemoryImage(restaurant.image ?? kTransparentImage),
                  ),
                  MyGrid(restaurant: restaurant),
                ],
              ),
            ),
            OrderTab(
              active: restaurant.active,
            ),
          ],
        ),
      ),
    );
  }
}

class MyGrid extends StatelessWidget {
  final Restaurant restaurant;

  MyGrid({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 2,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      children: List<Widget>.generate(
        restaurant.menu.length,
        (index) => MenuItemWidget(
          menuItem: restaurant.menu[index],
          active: restaurant.active,
        ),
      ),
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Želite li izaći iz ovog restorana?',
      ),
      content: Text(
        'Imate jela u košarici!',
      ),
      buttonPadding: EdgeInsets.all(10.0),
      actions: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('NE'),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('DA'),
          ),
        ),
      ],
      elevation: 20.0,
    );
  }
}
