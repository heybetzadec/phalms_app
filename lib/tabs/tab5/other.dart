import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phalmsapp/help/base_app_bar.dart';
import 'package:phalmsapp/help/event_key.dart';
import 'package:phalmsapp/help/route_bus.dart';
import 'package:phalmsapp/help/translations.dart';
import 'package:phalmsapp/main.dart';

class Other extends StatefulWidget {
  final RouteBus routeBus;

  Other({Key key, this.routeBus}) : super(key: key);

  @override
  _OtherState createState() => _OtherState(routeBus);
}

class _OtherState extends State<Other> {
  final RouteBus routeBus;
  int _n = 1;

  _OtherState(this.routeBus);

  List _langs =
  ["Engilish", "Türkçe"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentLang;

  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 1) _n--;
    });
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentLang = _dropDownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        routeBus: routeBus,
        title: Translations.of(context).text("psalms"),
        appBar: AppBar(),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 20
                  ),
                  child: Text(
                    "Dil sec:",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                DropdownButton(
                  value: _currentLang,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: new FloatingActionButton(
                    onPressed: minus,
                    child: new Icon(
                        const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                        color: Colors.black),
                    backgroundColor: Colors.white,
                  ),
                ),
                new Text('$_n', style: new TextStyle(fontSize: 30.0)),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: new FloatingActionButton(
                    onPressed: add,
                    child: new Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  void changedDropDownItem(String _currentLang) {
    if(_currentLang == _langs[0]){
      Locale newLocale = Locale('en', 'TR');
      Main.setLocale(context, newLocale);
    } else {
      Locale newLocale = Locale('tr', 'TR');
      Main.setLocale(context, newLocale);
    }

    setState(() {
      this._currentLang = _currentLang;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _langs) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }
    return items;
  }

}
