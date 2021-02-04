import 'package:EatUpRestaurantApp/constants.dart';
import 'package:EatUpRestaurantApp/services/authservice.dart';
import 'package:EatUpRestaurantApp/services/database.dart';
import 'package:EatUpRestaurantApp/widgets/change_activity_alert_dialog.dart';
import 'package:EatUpRestaurantApp/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: kAccentColor,
            ),
          ),
          NameTile(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.grey.shade300,
            height: 1,
          ),
          WorkingButton(),
          Spacer(),
          LogoutButton(),
        ],
      ),
    );
  }
}

class NameTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        Provider.of<Data>(context).restaurant.name == null
            ? 'EatUp'
            : 'Pozdrav ' + Provider.of<Data>(context).restaurant.name,
      ),
      leading: Icon(
        Icons.person,
        size: 35,
        color: kAccentColor,
      ),
    );
  }
}

class WorkingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        Provider.of<Data>(context).restaurant.active
            ? 'TRENUTNO RADIMO'
            : 'TRENUTNO NE RADIMO',
      ),
      trailing: Switch(
        activeColor: kAccentColor,
        onChanged: (value) async {
          var answer = await showDialog(
            context: context,
            builder: (context) => ChangeActivityAlertDialog(opening: value),
          );
          if (answer == true)
            Provider.of<Data>(context, listen: false).setActivity(value);
        },
        value: Provider.of<Data>(context).restaurant.active,
      ),
    );
  }
}

class LogoutButton extends StatefulWidget {
  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool aboutToLogout = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (aboutToLogout == false)
          setState(() {
            aboutToLogout = true;
          });
      },
      child: Container(
        color: kAccentColor,
        height: 50,
        child: aboutToLogout
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text(
                    'Jeste li sigurni?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  YesNoButton(
                    title: 'NE',
                    onTap: () {
                      setState(() {
                        aboutToLogout = false;
                      });
                    },
                  ),
                  SizedBox(width: 5),
                  YesNoButton(
                    title: 'DA',
                    onTap: () {
                      AuthService().signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => AuthService().handleAuth(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  SizedBox(width: 10),
                ],
              )
            : Align(
                alignment: Alignment.center,
                child: Text(
                  'ODJAVI ME',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}

class YesNoButton extends StatelessWidget {
  final Function onTap;
  final String title;

  YesNoButton({this.onTap, this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: kAccentColor,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}