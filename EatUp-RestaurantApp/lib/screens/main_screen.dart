import 'package:EatUpRestaurantApp/services/database.dart';
import 'package:EatUpRestaurantApp/widgets/order_tile.dart';
import 'package:EatUpRestaurantApp/widgets/kitchen_tile.dart';
import 'package:flutter/material.dart';

//Constants
import 'package:EatUpRestaurantApp/constants.dart';

//Widgets
import 'package:EatUpRestaurantApp/widgets/logo.dart';

//Drawer
import 'package:EatUpRestaurantApp/drawers/profile_drawer.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: ProfileDrawer(),
        appBar: AppBar(
          backgroundColor: kAccentColor,
          centerTitle: true,
          title: EatUpLogo(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex,
          onTap: (int index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          selectedItemColor: kAccentColor,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Stack(
                overflow: Overflow.visible,
                children: [
                  Icon(
                    Icons.format_list_bulleted,
                    size: 25,
                  ),
                  if (Provider.of<Data>(context).incomingOrders.length != 0)
                    Positioned(
                      top: -6,
                      right: -5 -
                          Provider.of<Data>(context)
                                  .incomingOrders
                                  .length
                                  .toString()
                                  .length *
                              4.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        child: Text(
                          Provider.of<Data>(context)
                              .incomingOrders
                              .length
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                ],
              ),
              title: Text(
                'Narudžbe',
              ),
            ),
            BottomNavigationBarItem(
              icon: Stack(
                overflow: Overflow.visible,
                children: [
                  Icon(
                    Icons.format_list_numbered,
                    size: 25,
                  ),
                  if (Provider.of<Data>(context).kitchenOrders.length != 0)
                    Positioned(
                      top: -6,
                      right: -5 -
                          Provider.of<Data>(context)
                                  .kitchenOrders
                                  .length
                                  .toString()
                                  .length *
                              4.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        child: Text(
                          Provider.of<Data>(context)
                              .kitchenOrders
                              .length
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                ],
              ),
              title: Text(
                'U kuhinji',
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _currentPageIndex == 0
                    ? Provider.of<Data>(context).incomingOrders.length
                    : Provider.of<Data>(context).kitchenOrders.length,
                itemBuilder: (context, index) => _currentPageIndex == 0
                    ? OrderTile(
                        order: Provider.of<Data>(context).incomingOrders[index],
                      )
                    : KitchenTile(
                        order: Provider.of<Data>(context).kitchenOrders[index],
                      ),
              ),
            )
          ],
        ));
  }
}
