import 'package:flutter/material.dart';
import 'package:EatUpUserApp/constants.dart';

//Objects
import 'package:EatUpUserApp/models/menu_item_object.dart';

//Widgets
import 'package:EatUpUserApp/widgets/my_sliver_appbar.dart';
import 'package:EatUpUserApp/widgets/meal_tile.dart';
import 'package:EatUpUserApp/widgets/order_tab.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:EatUpUserApp/services/database.dart';

class MenuItemScreen extends StatelessWidget {
  final MenuItem menuItem;
  final bool active;

  MenuItemScreen({this.menuItem, this.active});

  @override
  Widget build(BuildContext context) {
    Provider.of<Data>(context, listen: false).selectedDescription = null;

    String image;

    if (!supportedImages.contains(menuItem.image)) {
      image = 'default';
    } else {
      image = menuItem.image;
    }
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                MySliverAppBar(
                  title: menuItem.name,
                  image: AssetImage('assets/menu_items/' + image + '.jpg'),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => MealTile(
                      meal: menuItem.meals[index],
                      active: active,
                      index: index,
                    ),
                    childCount: menuItem.meals.length,
                  ),
                ),
              ],
            ),
          ),
          OrderTab(
            active: active,
          ),
        ],
      ),
    );
  }
}
