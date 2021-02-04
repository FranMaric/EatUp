import 'package:EatUpUserApp/constants.dart';
import 'package:EatUpUserApp/services/database.dart';
import 'package:flutter/material.dart';

//Objects
import 'package:EatUpUserApp/models/meal_object.dart';
import 'package:EatUpUserApp/models/order_object.dart';
import 'package:provider/provider.dart';

class MealTile extends StatelessWidget {
  final Meal meal;
  final bool active;
  final int index;

  MealTile({
    this.meal,
    this.active,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    String price;
    if (meal.price == 0) {
      price = '-';
    } else if (meal.price.floor() == meal.price.toDouble()) {
      price = meal.price.round().toString();
    } else {
      price = meal.price.toString() +
          (meal.price.toString().length - meal.price.toString().indexOf('.') ==
                  2
              ? '0'
              : '');
    }
    return Container(
      decoration: BoxDecoration(
        boxShadow: shadows,
        color: kBackgroundColor,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (meal.description != null) {
                      if (Provider.of<Data>(context, listen: false)
                              .selectedDescription !=
                          index) {
                        Provider.of<Data>(context, listen: false)
                            .selectedDescription = index;
                      } else {
                        Provider.of<Data>(context, listen: false)
                            .selectedDescription = null;
                      }
                      Provider.of<Data>(context, listen: false).notify();
                    }
                  },
                  child: ListTile(
                    title: Text(
                      meal.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: meal.description == null
                        ? null
                        : Text(
                            meal.description ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    trailing: Text(
                      price + ' kn',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: active && meal.price != 0,
                child: Provider.of<Order>(context).meals.contains(meal)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'x' +
                                (Provider.of<Order>(context)
                                        .meals
                                        .contains(meal)
                                    ? Provider.of<Order>(context)
                                        .quantity[Provider.of<Order>(context)
                                            .meals
                                            .indexOf(meal)]
                                        .toString()
                                    : ''),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          MyIconButton(
                            icon: Icons.remove,
                            onTap: () {
                              Provider.of<Order>(context, listen: false)
                                  .changeMealState(meal, -1);
                            },
                          ),
                          SizedBox(width: 5.0),
                          MyIconButton(
                            icon: Icons.add,
                            onTap: () {
                              Provider.of<Order>(context, listen: false)
                                  .changeMealState(meal, 1);
                            },
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          Provider.of<Order>(context, listen: false)
                              .changeMealState(meal, 0);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: Text(
                            'ODABERI',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: kAccentColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
              ),
              SizedBox(width: 5.0),
            ],
          ),
          if (Provider.of<Data>(context).selectedDescription == index)
            Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    meal.description ?? 'nema opisa',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;

  MyIconButton({this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kAccentColor,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
