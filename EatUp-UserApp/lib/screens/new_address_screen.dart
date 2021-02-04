import 'package:EatUpUserApp/widgets/area_picker.dart';
import 'package:EatUpUserApp/widgets/logo.dart';
import 'package:flutter/material.dart';

//Objects
import 'package:EatUpUserApp/models/address_object.dart';

//Widgets
import 'package:EatUpUserApp/widgets/rounded_button.dart';
import 'package:EatUpUserApp/widgets/stan_kat_checker.dart';
import 'package:EatUpUserApp/widgets/text_field_container.dart';

//Constants
import 'package:EatUpUserApp/constants.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:EatUpUserApp/services/database.dart';

class NewAddressScreen extends StatefulWidget {
  final bool setItToFavoriteAddress;

  NewAddressScreen({this.setItToFavoriteAddress = false});

  @override
  _NewAddressScreenState createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  String ulica;
  String brojKuce;
  String grad;
  String surname;

  String selectedKat;
  bool stan;
  bool inputError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: EatUpLogo(),
        backgroundColor: kAccentColor,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: MyTextField(
                          horizMargin: 1,
                          title: 'Ulica',
                          keyboardType: TextInputType.text,
                          onChanged: (String newValue) {
                            ulica = newValue
                                .replaceAll(RegExp(r'[0-9]'), '')
                                .trim();
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: MyTextField(
                          horizMargin: 1,
                          title: 'Kućni broj',
                          keyboardType: TextInputType.text,
                          onChanged: (String newValue) {
                            brojKuce = '';
                            newValue = newValue.toUpperCase().trim();
                            newValue.split('').forEach(
                              (char) {
                                if ('0123456789AB'.contains(char)) {
                                  brojKuce += char;
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                StanKatChecker(
                  onChange: (value, selection) {
                    stan = value;
                    selectedKat = selection;
                  },
                ),
                MyTextField(
                  title: 'Prezime na vratima',
                  keyboardType: TextInputType.text,
                  onChanged: (String newValue) {
                    surname = newValue.trim();
                  },
                ),
                AreaPicker(
                  onChange: (value) => grad = value,
                ),
                Visibility(
                  visible: inputError,
                  child: Text(
                    'Nisu sva polja ispunjena ili su krivi podatci!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RoundedButton(
                  title: 'DODAJ',
                  onTap: () {
                    if (validInput()) {
                      Address address = Address(
                        area: grad == null ? 'Vinkovci' : grad,
                        building: stan,
                        houseNumber: brojKuce,
                        level: (!stan || selectedKat == 'prizemlje')
                            ? 0
                            : selectedKat,
                        street: ulica,
                        surname: surname,
                      );
                      Provider.of<Data>(context, listen: false)
                          .addAddress(address, widget.setItToFavoriteAddress);

                      Navigator.of(context).pop();
                      //
                    } else if (!inputError) {
                      setState(() {
                        inputError = true;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validInput() => validAddres(
        street: ulica,
        houseNumber: brojKuce,
        area: grad == null ? 'Vinkovci' : grad,
        surname: surname,
      );
}
