import 'package:flutter/material.dart';
import 'package:EatUpUserApp/constants.dart';

//Objects
import 'package:EatUpUserApp/models/menu_item_object.dart';

//Screens
import 'package:EatUpUserApp/screens/menu_item_screen.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItem menuItem;
  final bool active;

  MenuItemWidget({this.menuItem, this.active});

  @override
  Widget build(BuildContext context) {
    String image;

    if (!supportedImages.contains(menuItem.image)) {
      image = 'default';
    } else {
      image = menuItem.image;
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MenuItemScreen(
            menuItem: menuItem,
            active: active,
          ),
        ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.width * 0.5,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[500],
          image: DecorationImage(
            image: AssetImage('assets/menu_items/' + image + '.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
            decoration: BoxDecoration(
              color: kAccentColor,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Text(
              menuItem.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
