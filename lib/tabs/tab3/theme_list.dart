import 'package:flutter/material.dart';
import 'package:phalmsapp/help/base_app_bar.dart';
import 'package:phalmsapp/help/const.dart';
import 'package:phalmsapp/help/route_bus.dart';
import 'package:phalmsapp/tabs/tab3/phrase_list.dart';
import 'package:tinycolor/tinycolor.dart';

class ThemeList extends StatefulWidget {
  final RouteBus routeBus;

  ThemeList({Key key, this.routeBus}) : super(key: key);

  @override
  _ThemeListState createState() => _ThemeListState(routeBus);
}

class _ThemeListState extends State<ThemeList> {
  final RouteBus routeBus;

  _ThemeListState(this.routeBus);

  var dataList = new List<Map<String, dynamic>>();

  @override
  void initState() {
    routeBus.dbf.then((db) {
      db.rawQuery("SELECT theme_id, theme_name  FROM theme;").then((value) {
        setState(() {
          dataList = value.toList();
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: BaseAppBar(
        title: 'Sura',
        appBar: AppBar(),
      ),
      body: Container(
        margin: EdgeInsets.only(
            top: 2
        ),
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            var itemValue = dataList[index].values;
            return new Card(
              margin: EdgeInsets.only(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 1
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              elevation: 1,
              child: new InkWell(
                onTap: (){
                  Navigator.of(context).push(
                      Const.customRoute((context) {
                        return PhraseList(
                          routeBus: routeBus,
                          themeId: itemValue.first,
                        );
                      })
                  );
                },
                child: ListTile(
                  title: Text(' ${itemValue.last}'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

  }
}
