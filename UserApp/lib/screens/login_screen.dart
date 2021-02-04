import 'package:EatUpUserApp/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:EatUpUserApp/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

//Firebase
import 'package:firebase_auth/firebase_auth.dart';

//Widgets
import 'package:EatUpUserApp/widgets/text_field_container.dart';
import 'package:EatUpUserApp/widgets/rounded_button.dart';

//Service
import 'package:EatUpUserApp/services/authService.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String verificationId;
  String brojMobitela = '';

  String smsCode = '';
  bool isSent = false;

  String dropDownValue = '+385';

  bool error = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPhoneNumber();
  }

  setPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phoneNumber', brojMobitela);
    prefs.setString('phoneCode', dropDownValue);
  }

  getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    brojMobitela = prefs.getString('phoneNumber') ?? '';
    dropDownValue = prefs.getString('phoneCode') ?? '+385';
    setState(() {
      controller.text = brojMobitela;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: EatUpLogo(),
        backgroundColor: kAccentColor,
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: !isSent,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 22.0),
                        child: Row(
                          children: <Widget>[
                            DropdownButton<String>(
                              hint: Text('+385'),
                              value: dropDownValue,
                              items: supportedPhoneCodes.map(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropDownValue = value;
                                });
                              },
                            ),
                            Expanded(
                              child: MyTextField(
                                title: 'Broj mobitela',
                                horizMargin: 0.0,
                                controller: controller,
                                keyboardType: TextInputType.phone,
                                onChanged: (String newInput) {
                                  brojMobitela = newInput;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: error,
                          child: Text(
                              'Dogodila se pogreška pokušajte ponovno kasnije.'))
                    ],
                  ),
                ),
                Visibility(
                  visible: isSent,
                  child: MyTextField(
                    title: 'Kod iz poruke',
                    keyboardType: TextInputType.number,
                    onChanged: (String newInput) {
                      smsCode = newInput;
                    },
                  ),
                ),
                isSent
                    ? RoundedButton(
                        onTap: () => AuthService()
                            .signInWithSmsCode(smsCode, verificationId),
                        title: 'ULAZ',
                      )
                    : RoundedButton(
                        onTap: () {
                          setPhoneNumber();
                          verifyPhone(dropDownValue + brojMobitela);
                        },
                        title: 'DALJE',
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNumber) async {
    final PhoneVerificationCompleted verified =
        (AuthCredential authCredential) {
      AuthService().signIn(authCredential);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      verificationId = verId;
      setState(() {
        isSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
}
