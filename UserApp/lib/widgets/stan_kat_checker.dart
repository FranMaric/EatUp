import 'package:EatUpUserApp/constants.dart';
import 'package:flutter/material.dart';

class StanKatChecker extends StatefulWidget {
  final Function onChange;

  StanKatChecker({this.onChange});

  @override
  _StanKatCheckerState createState() => _StanKatCheckerState();
}

class _StanKatCheckerState extends State<StanKatChecker> {
  bool stan;

  List<String> katovi = <String>['prizemlje'] +
      List.generate(69, (index) => (index + 1).toString() + '.');

  String selectedKat = 'prizemlje';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          margin: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            children: <Widget>[
              _Selector(
                title: 'KUĆA',
                active: stan == false,
                onTap: () {
                  setState(() {
                    stan = false;
                  });
                  widget.onChange(false, selectedKat);
                },
              ),
              _Selector(
                title: 'ZGRADA',
                active: stan == true,
                onTap: () {
                  setState(() {
                    stan = true;
                  });
                  widget.onChange(true, selectedKat);
                },
              ),
            ],
          ),
        ),
        Visibility(
          visible: stan == true,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    'KAT:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: selectedKat,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  onChanged: (value) {
                    setState(() {
                      selectedKat = value;
                    });
                    widget.onChange(stan, selectedKat);
                  },
                  elevation: 16,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                  items: katovi
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _Selector extends StatelessWidget {
  final bool active;
  final String title;
  final Function onTap;

  _Selector({
    this.active,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: active == true ? kAccentColor : kBackgroundColor,
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
