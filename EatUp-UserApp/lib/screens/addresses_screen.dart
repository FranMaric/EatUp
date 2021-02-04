import 'package:flutter/material.dart';
import 'package:EatUpUserApp/constants.dart';

//Widgets
import 'package:EatUpUserApp/widgets/address_tile.dart';
import 'package:EatUpUserApp/widgets/logo.dart';
import 'package:EatUpUserApp/models/address_object.dart';

import 'package:EatUpUserApp/screens/new_address_screen.dart'; //Screen

//Services
import 'package:provider/provider.dart';
import 'package:EatUpUserApp/services/database.dart';

class AddressesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Address> addresses = Provider.of<Data>(context).user.addresses;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: EatUpLogo(),
        backgroundColor: kAccentColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: Provider.of<Data>(context).user.addresses == null
                  ? 0
                  : Provider.of<Data>(context, listen: true)
                      .user
                      .addresses
                      .length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                child: (Provider.of<Data>(context).user.addresses == null
                            ? 0
                            : Provider.of<Data>(context, listen: true)
                                .user
                                .addresses
                                .length) ==
                        1
                    ? AddressTile(
                        address: addresses[index],
                        color: Colors.white,
                      )
                    : ExpandingAddressTile(
                        address: addresses[index],
                        color: Colors.white,
                        index: index,
                      ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (Provider.of<Data>(context, listen: false)
                      .user
                      .addresses
                      .length <
                  6) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NewAddressScreen()),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Maksimalan broj adresa'),
                    content: Text('Ne možeš napraviti više od 6 adresa!'),
                  ),
                );
              }
            },
            child: Container(
              width: double.infinity,
              height: 60,
              color: kAccentColor,
              alignment: Alignment.center,
              child: Text(
                'NOVA ADRESA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
