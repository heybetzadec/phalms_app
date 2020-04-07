import 'package:flutter/material.dart';
import 'package:phalmsapp/help/route_bus.dart';
import 'package:phalmsapp/main.dart';

class Other extends StatefulWidget {
  final RouteBus routeBus;

  Other({Key key, this.routeBus}) : super(key: key);

  @override
  _OtherState createState() => _OtherState(routeBus);
}

class _OtherState extends State<Other> {
  final RouteBus routeBus;

  _OtherState(this.routeBus);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: MaterialButton(
            onPressed: () {
              Locale newLocale = Locale('tr', 'TR');
              Main.setLocale(context, newLocale);
            },
            child: Text('Dil deyis'),
          ),
        ),
      ),
    );
  }
}
