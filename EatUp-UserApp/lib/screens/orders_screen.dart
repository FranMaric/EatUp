import 'package:EatUpUserApp/constants.dart';
import 'package:EatUpUserApp/services/database.dart';
import 'package:EatUpUserApp/widgets/logo.dart';
import 'package:EatUpUserApp/widgets/orders_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool noOrders() {
      return !((Provider.of<Data>(context, listen: false).user.waitingOrders !=
                  null &&
              Provider.of<Data>(context, listen: false)
                      .user
                      .waitingOrders
                      .length !=
                  0) ||
          (Provider.of<Data>(context, listen: false).user.processedOrders !=
                  null &&
              Provider.of<Data>(context, listen: false)
                      .user
                      .processedOrders
                      .length !=
                  0));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: EatUpLogo(),
        backgroundColor: kAccentColor,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: Provider.of<Data>(context).getOrders(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return Text('Greška: ${snapshot.error}');
                else
                  return Column(
                    children: [
                      Expanded(
                        child: noOrders()
                            ? Center(
                                child: Text(
                                  'Još niste napravili svoju prvu narudžbu. Što čekate?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                        SizedBox(height: 10),
                                      ] +
                                      List<Widget>.from(Provider.of<Data>(
                                                          context)
                                                      .user
                                                      .waitingOrders ==
                                                  null ||
                                              Provider.of<Data>(context)
                                                      .user
                                                      .waitingOrders
                                                      .length ==
                                                  0
                                          ? []
                                          : <Widget>[
                                                Container(
                                                  width: double.infinity,
                                                  // height: 80,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: kAccentColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Text(
                                                    'Narudžbe na čekanju',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ] +
                                              Provider.of<Data>(context)
                                                  .user
                                                  .waitingOrders
                                                  .map(
                                                    (order) => OrdersTile(
                                                      order: order,
                                                      waitingOrder: true,
                                                    ),
                                                  )
                                                  .toList()) +
                                      List<Widget>.from(Provider.of<Data>(
                                                          context)
                                                      .user
                                                      .processedOrders ==
                                                  null ||
                                              Provider.of<Data>(context)
                                                      .user
                                                      .processedOrders
                                                      .length ==
                                                  0
                                          ? []
                                          : <Widget>[
                                                Container(
                                                  width: double.infinity,
                                                  // height: 80,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: kAccentColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Text(
                                                    'Povijest narudžbi',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ] +
                                              Provider.of<Data>(context)
                                                  .user
                                                  .processedOrders
                                                  .map(
                                                    (order) => OrdersTile(
                                                      order: order,
                                                    ),
                                                  )
                                                  .toList()),
                                ),
                              ),
                      ),
                    ],
                  );
            }
          },
        ),
      ),
    );
  }
}
