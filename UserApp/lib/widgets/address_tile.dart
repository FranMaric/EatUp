import 'package:EatUpUserApp/constants.dart';
import 'package:EatUpUserApp/models/address_object.dart';
import 'package:EatUpUserApp/services/database.dart';
import 'package:EatUpUserApp/widgets/address_delete_alert_dialog.dart';
import 'package:EatUpUserApp/widgets/addresses_bottom_sheet.dart';
import 'package:EatUpUserApp/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddressTile extends StatelessWidget {
  final Address address;
  final Color color;

  AddressTile({
    this.address,
    this.color = kBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: kAccentColor,
          width: 0.2,
        ),
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListTile(
        title: Text(
          address.street + ' ' + address.houseNumber,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          address.area,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: FaIcon(
          address.building ? FontAwesomeIcons.building : FontAwesomeIcons.home,
          color: Colors.black,
        ),
      ),
    );
  }
}

class AddressTileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    try {
      Address address = Provider.of<Data>(context)
          .user
          .addresses[Provider.of<Data>(context).user.favAddress];

      return GestureDetector(
        child: AddressTile(address: address),
        onTap: () {
          showModalBottomSheet(
              context: context, builder: (context) => AddressesBotomSheet());
        },
      );
    } catch (e) {
      return Container();
    }
  }
}

class ExpandingAddressTile extends StatefulWidget {
  final Address address;
  final Color color;
  final int index;

  ExpandingAddressTile({
    this.address,
    this.color,
    this.index,
  });

  @override
  _ExpandingAddressTileState createState() => _ExpandingAddressTileState();
}

class _ExpandingAddressTileState extends State<ExpandingAddressTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Column(
        children: [
          AddressTile(
            address: widget.address,
            color: widget.color,
          ),
          Visibility(
            visible: expanded,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                children: [
                  Expanded(
                    child: RoundedButton(
                      title: 'OBRIŠI',
                      horizMargin: 5,
                      onTap: () async {
                        if (Provider.of<Data>(context, listen: false)
                                .user
                                .addresses
                                .length ==
                            1) return;

                        bool answer = await showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AddressDeleteAlertDialog(),
                        );

                        if (answer == true)
                          Provider.of<Data>(context, listen: false)
                              .removeAddress(widget.index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
