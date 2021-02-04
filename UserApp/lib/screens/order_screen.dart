import 'package:flutter/material.dart';
import 'package:EatUpUserApp/constants.dart';

//Objects
import 'package:EatUpUserApp/models/order_object.dart';

//Widgets
import 'package:EatUpUserApp/widgets/order_tile.dart';
import 'package:EatUpUserApp/widgets/text_field_container.dart';

//Screens
import 'package:EatUpUserApp/screens/succesful_order_screen.dart';
import 'package:EatUpUserApp/screens/error_order_screen.dart';

//Services
import 'package:provider/provider.dart';
import 'package:EatUpUserApp/services/database.dart';

class OrderScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kAccentColor,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Narudžba',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 27.0,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: Provider.of<Order>(context).meals.length,
              itemBuilder: (BuildContext context, int index) => OrderTile(
                meal: Provider.of<Order>(context).meals[index],
                quantity: Provider.of<Order>(context).quantity[index],
              ),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(width: 10),
                Text(
                  'Sveukupno:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  Provider.of<Order>(context).total.toString() + ' kn',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          MyTextField(
            controller: controller,
            title: 'Napomena',
            maxLines: 3,
          ),
          Provider.of<Data>(context).loading
              ? Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: kAccentColor,
                  ),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    strokeWidth: 3.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Provider.of<Data>(context, listen: false).setLoading(true);
                    Provider.of<Order>(context, listen: false).note =
                        controller.text;

                    Provider.of<Order>(context, listen: false)
                        .makeAnOrder(context,
                            Provider.of<Data>(context, listen: false).user)
                        .then(
                      (value) {
                        Provider.of<Data>(context, listen: false)
                            .setLoading(false);
                        if (value == true) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => SuccesfulOrderScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ErrorOrderScreen(),
                            ),
                          );
                        }
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: kAccentColor,
                    ),
                    child: Text(
                      'NARUČI',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
