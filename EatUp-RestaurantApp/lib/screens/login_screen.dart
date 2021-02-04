import 'package:flutter/material.dart';
import 'package:EatUpRestaurantApp/constants.dart';

//Widgets
import 'package:EatUpRestaurantApp/widgets/text_field_container.dart';
import 'package:EatUpRestaurantApp/widgets/rounded_button.dart';
import 'package:EatUpRestaurantApp/widgets/logo.dart';

//Service
import 'package:EatUpRestaurantApp/services/authService.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kAccentColor,
        centerTitle: true,
        title: EatUpLogo(),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                MyTextField(
                  title: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                MyTextField(
                  title: 'Lozinka',
                  controller: passController,
                  keyboardType: TextInputType.text,
                ),
                RoundedButton(
                  onTap: () => AuthService().signInWithEmail(
                      emailController.text, passController.text),
                  title: 'ULAZ',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
