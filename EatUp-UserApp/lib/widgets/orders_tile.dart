import 'package:flutter/material.dart';

class OrdersTile extends StatelessWidget {
  final dynamic order;
  final bool waitingOrder;

  OrdersTile({
    this.order,
    this.waitingOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    String title = '';
    String subtitle = '';

    DateTime datetime1 =
        DateTime.fromMicrosecondsSinceEpoch(order['userTimestamp'] * 1000);

    String date1 =
        '${datetime1.hour}:${datetime1.minute} - ${datetime1.day}/${datetime1.month}/${datetime1.year}';

    title += order['address']['street'] + ' ' + order['address']['houseNumber'];

    subtitle += '$date1\n\n';

    // if (!waitingOrder) {
    //   DateTime datetime2 = DateTime.fromMicrosecondsSinceEpoch(
    //       order['restaurantTimestamp'] * 1000);

    //   String date2 =
    //       '${datetime2.hour}:${datetime2.minute} - ${datetime2.day}/${datetime2.month}/${datetime2.year}';
    //   subtitle += 'Reakcija restorana: $date2\n';
    // }

    for (var i = 0;
        i < (order['meals'] == null ? 0 : order['meals'].length);
        i++) {
      double wholePrice = double.parse(order['meals'][i]['price'].toString()) *
          double.parse(order['meals'][i]['amount'].toString());
      subtitle += order['meals'][i]['name'].toString() +
          ' X ' +
          order['meals'][i]['amount'].toString() +
          ' = ' +
          wholePrice.toString() +
          ' kn' +
          '\n';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
