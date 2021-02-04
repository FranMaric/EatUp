import 'package:EatUpRestaurantApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:EatUpRestaurantApp/constants.dart';

//Widgets
import 'package:EatUpRestaurantApp/widgets/rounded_button.dart';
import 'package:EatUpRestaurantApp/widgets/accept_alert_dialog.dart';
import 'package:EatUpRestaurantApp/widgets/decline_alert_dialog.dart';

//Models
import 'package:EatUpRestaurantApp/models/order_object.dart';
import 'package:provider/provider.dart';

class OrderTile extends StatefulWidget {
  final Order order;

  OrderTile({this.order});

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
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
                          title: 'ODBIJ',
                          onTap: () => _declineOrder(context),
                        ),
                      ),
                      Expanded(
                        child: RoundedButton(
                          title: 'PRIHVATI',
                          onTap: () => _acceptOrder(context),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      );

  void _declineOrder(BuildContext context) async {
    var answer = await showDialog(
      context: context,
      builder: (context) => DeclineAlertDialog(),
    );

    if (answer != null && answer != false) {
      String uid = Provider.of<Data>(context, listen: false).restaurant.uid;
      setState(() {
        loading = true;
      });

      Map<String, dynamic> update = {
        'accepted': false,
        'restaurantNote': answer[1],
        'restaurantTimestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await Firestore.instance
          .collection('restaurants')
          .document(uid)
          .collection('orders')
          .document(widget.order.documentID)
          .updateData(update)
          .then((value) {
        Future.delayed(Duration(seconds: 3)).then((value) {
          setState(() {
            loading = false;
          });
        });
      });
    }
  }

  void _acceptOrder(BuildContext context) async {
    var answer = await showDialog(
      context: context,
      builder: (context) => AcceptAlertDialog(),
    );

    if (answer != null && answer != false) {
      String uid = Provider.of<Data>(context, listen: false).restaurant.uid;
      setState(() {
        loading = true;
      });

      Map<String, dynamic> update = {
        'accepted': true,
        'sent': false,
        'restaurantNote': answer[1],
        'restaurantTimestamp': DateTime.now().millisecondsSinceEpoch,
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
