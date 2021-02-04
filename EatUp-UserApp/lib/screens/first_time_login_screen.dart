import 'dart:io';

import 'package:EatUpUserApp/models/notification_manager.dart';
import 'package:EatUpUserApp/screens/main_screen.dart';
import 'package:EatUpUserApp/services/database.dart';
import 'package:EatUpUserApp/widgets/area_picker.dart';
import 'package:EatUpUserApp/widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Widgets
import 'package:EatUpUserApp/widgets/rounded_button.dart';
import 'package:EatUpUserApp/widgets/stan_kat_checker.dart';
import 'package:EatUpUserApp/widgets/text_field_container.dart';

//Constants
import 'package:EatUpUserApp/constants.dart';
import 'package:provider/provider.dart';

class FirstTimeLoginScreen extends StatefulWidget {
  @override
  _FirstTimeLoginScreenState createState() => _FirstTimeLoginScreenState();
}

class _FirstTimeLoginScreenState extends State<FirstTimeLoginScreen> {
  String ime = '';
  String prezime = '';
  String ulica = '';
  String brojKuce;
  String grad = '';
  String surname = '';

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
      body: Center(
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
                      child: MyTextField(
                        horizMargin: 1,
                        title: 'Ime',
                        keyboardType: TextInputType.text,
                        onChanged: (String newValue) {
                          ime = newValue.trim();
                        },
                      ),
                    ),
                    Expanded(
                      child: MyTextField(
                        horizMargin: 1,
                        title: 'Prezime',
                        keyboardType: TextInputType.text,
                        onChanged: (String newValue) {
                          prezime = newValue.trim();
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
                          ulica =
                              newValue.replaceAll(RegExp(r'[0-9]'), '').trim();
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: MyTextField(
                        horizMargin: 1,
                        title: 'Kućni broj',
                        // "Broj " +
                        //     ((stan == true ?? false) ? 'zgrade' : 'kuce'),
                        keyboardType: TextInputType.text,
                        onChanged: (String newValue) {
                          brojKuce = '';
                          newValue = newValue.toUpperCase().trim();
                          newValue.split('').forEach((char) {
                            if ('0123456789AB'.contains(char)) {
                              brojKuce += char;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              MyTextField(
                title: 'Prezime na vratima',
                keyboardType: TextInputType.text,
                onChanged: (String newValue) {
                  surname = newValue.trim();
                },
              ),
              StanKatChecker(
                onChange: (value, selection) {
                  stan = value;
                  selectedKat = selection;
                },
              ),
              AreaPicker(
                onChange: (value) {
                  grad = value;
                  print(grad);
                },
              ),
              Visibility(
                visible: inputError,
                child: Text(
                  'Nisu sva polja ispunjena!!!',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RoundedButton(
                onTap: () async {
                  if (validInput()) {
                    if ([null, '', ' '].contains(grad)) grad = 'Vinkovci';

                    Map<String, Object> collection = {
                      'name': ime + ' ' + prezime,
                      'addresses': [
                        {
                          'street': ulica,
                          'houseNumber': brojKuce,
                          'building': stan,
                          'level': (!stan || selectedKat == 'prizemlje')
                              ? 0
                              : selectedKat,
                          'area': grad,
                          'surname': surname,
                        },
                      ],
                      'favAddress': 0,
                      'banned': false,
                      'phoneNumber': Provider.of<Data>(context, listen: false)
                          .user
                          .phoneNumber,
                      'lastOrderTimestamp': 0,
                      'platform': Platform.operatingSystem,
                    };
                    Provider.of<Data>(context, listen: false).area = grad;
                    Provider.of<Data>(context, listen: false).getRestaurants();

                    Provider.of<NotificationManager>(context, listen: false)
                        .setup(
                            Provider.of<Data>(context, listen: false).user.uid);

                    Provider.of<Data>(context, listen: false)
                        .user
                        .setupFromFirstTimeLoginScreen(collection);

                    await Firestore.instance
                        .collection('users')
                        .document(
                            Provider.of<Data>(context, listen: false).user.uid)
                        .setData(collection);

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } else if (!inputError) {
                    setState(() {
                      inputError = true;
                    });
                  }
                },
                title: 'DALJE',
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validInput() {
    return ['', ' ', null].contains(ime) &&
        ime.length >= 2 &&
        ['', ' ', null].contains(prezime) &&
        prezime.length >= 2 &&
        validAddres(
          street: ulica,
          houseNumber: brojKuce,
          area: grad,
          surname: surname,
        );
  }
}
