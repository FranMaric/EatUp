import 'package:EatUpUserApp/constants.dart';
import 'package:EatUpUserApp/screens/new_address_screen.dart';
import 'package:EatUpUserApp/services/database.dart';
import 'package:EatUpUserApp/widgets/address_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressesBotomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      height:
          100 * Provider.of<Data>(context).user.addresses.length.toDouble() +
              50,
      child: Container(
        padding: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
                  Text(
                    'Odaberi adresu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ] +
                Provider.of<Data>(context)
                    .user
                    .addresses
                    .map(
                      (e) => GestureDetector(
                        child: AddressTile(address: e),
                        onTap: () {
                          Provider.of<Data>(context, listen: false)
                              .newFavAddress(e);
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                    .toList() +
                <Widget>[
                  if (Provider.of<Data>(context).user.addresses.length < 6)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NewAddressScreen(
                              setItToFavoriteAddress: true,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kAccentColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 30,
                            child: Text(
                              'DODAJ ADRESU',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ],
          ),
        ),
      ),
    );
  }
}
