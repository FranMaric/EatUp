import 'package:EatUpRestaurantApp/constants.dart';
import 'package:EatUpRestaurantApp/services/database.dart';
import 'package:EatUpRestaurantApp/widgets/rounded_button.dart';
import 'package:EatUpRestaurantApp/widgets/send_order_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Models
import 'package:EatUpRestaurantApp/models/order_object.dart';
import 'package:provider/provider.dart';

class KitchenTile extends StatefulWidget {
  final Order order;

  KitchenTile({this.order});

  @override
  _KitchenTileState createState() => _KitchenTileState();
}

class _KitchenTileState extends State<KitchenTile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            color: kAccentColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.order.address.street} ${widget.order.address.houseNumber} - ${widget.order.address.surname}",
              style: titleStyle,
            ),
            SizedBox(height: 5),
            Text("Mobitel: ${widget.order.phoneNumber}", style: subtitleStyle),
            SizedBox(height: 10),
            for (int i = 0; i < widget.order.meals.length; i++)
              Text(
                "${widget.order.meals[i].name} x ${widget.order.meals[i].amount} = ${tryInt(double.parse(widget.order.meals[i].price) * widget.order.meals[i].amount)} kn",
                style: subtitleStyle,
              ),
            SizedBox(height: 10),
            if (!['', ' ', null].contains(widget.order.note))
              Text("Poruka: ${widget.order.note}", style: subtitleStyle),
            SizedBox(height: 5),
            loading
                ? Center(child: CircularProgressIndicator())
                : Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                          title: 'POSLANO JE',
                          onTap: () => _sendOrder(context),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      );

  void _sendOrder(BuildContext context) async {
    bool answer = await showDialog(
      context: context,
      builder: (context) => SendOrderAlertDialog(),
    );

    if (answer == true) {
      String uid = Provider.of<Data>(context, listen: false).restaurant.uid;
      setState(() {
        loading = true;
      });

      Map<String, dynamic> update = {
        'sent': true,
        'sentTimestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await Firestore.instance
          .collection('restaurants')
          .document(uid)
          .collection('orders')
          .document(widget.order.documentID)
          .updateData(update)
          .then((value) {
        Future.delayed(Duration(seconds: 1)).then((value) {
          try {
            setState(() {
              loading = false;
            });
          } catch (e) {}
        });
      });
    }
  }
}
