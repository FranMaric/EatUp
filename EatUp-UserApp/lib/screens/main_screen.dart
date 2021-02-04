import 'package:flutter/material.dart';
import 'package:EatUpUserApp/constants.dart';

//Screens
import 'package:EatUpUserApp/screens/loading_indicator.dart';

//Drawer
import 'package:EatUpUserApp/drawers/profile_drawer.dart';

//Widgets
import 'package:EatUpUserApp/widgets/list_of_restaurants.dart';
import 'package:EatUpUserApp/widgets/address_tile.dart';
import 'package:EatUpUserApp/widgets/logo.dart';
import 'package:EatUpUserApp/widgets/order_notification.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:EatUpUserApp/services/database.dart';
import 'package:EatUpUserApp/models/notification_manager.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        drawer: ProfileDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: EatUpLogo(),
          backgroundColor: kAccentColor,
        ),
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: AddressTileButton(),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Expanded(
                  child: Provider.of<Data>(context).restaurants.length > 0
                      ? ListOfRestaurants()
                      : Provider.of<Data>(context).restaurantsLoaded
                          ? Center(
                              child: Text(
                                'Nemamo restorana na području ${Provider.of<Data>(context, listen: false).area} :(',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                ),
              ],
            ),
            if (Provider.of<NotificationManager>(context).notify == true)
              GestureDetector(
                onTap: () =>
                    Provider.of<NotificationManager>(context, listen: false)
                        .removeNotification(),
                child: Container(
                  color: Color(0x55000000),
                  child: Center(
                    child: OrderNotification(),
                  ),
                ),
              )
          ],
        ),
      );
    } catch (e) {
      Provider.of<Data>(context).getRestaurants();
      return LoadingIndicator();
    }
  }
}
