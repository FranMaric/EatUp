import 'package:EatUpUserApp/constants.dart';
import 'package:EatUpUserApp/screens/addresses_screen.dart';
import 'package:EatUpUserApp/screens/orders_screen.dart';
import 'package:EatUpUserApp/services/authservice.dart';
import 'package:EatUpUserApp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
          OrderTile(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.grey.shade300,
            height: 1,
          ),
          AddressTile(),
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
        Provider.of<Data>(context).user.name == null
            ? 'EatUp'
            : 'Pozdrav ' + Provider.of<Data>(context).user.name.split(' ')[0],
      ),
      leading: Icon(
        Icons.person,
        size: 35,
        color: kAccentColor,
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Moje narudžbe'),
      leading: FaIcon(
        FontAwesomeIcons.listOl,
        color: kAccentColor,
        size: 35,
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down,
        color: kAccentColor,
      ),
      onTap: () {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
        ));
        Navigator.pop(context);
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => OrdersScreen()))
            .then((value) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: kBackgroundColor,
          ));
        });
      },
    );
  }
}

class AddressTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Moje adrese'),
      leading: FaIcon(
        Provider.of<Data>(context).user.addresses == null
            ? FontAwesomeIcons.home
            : Provider.of<Data>(context)
                        .user
                        .addresses[Provider.of<Data>(context).user.favAddress]
                        .building ==
                    true
                ? FontAwesomeIcons.building
                : FontAwesomeIcons.home,
        color: kAccentColor,
        size: 35,
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down,
        color: kAccentColor,
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddressesScreen()));
      },
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
