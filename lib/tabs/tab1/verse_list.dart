import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phalmsapp/help/base_app_bar.dart';
import 'package:phalmsapp/help/route_bus.dart';
import 'package:phalmsapp/help/translations.dart';

class VerseList extends StatefulWidget {
  final RouteBus routeBus;
  final int chapterId;

  VerseList({Key key, this.routeBus, this.chapterId}) : super(key: key);

  @override
  _VerseListState createState() => _VerseListState(routeBus, chapterId);
}

class _VerseListState extends State<VerseList> {
  final RouteBus routeBus;
  final int chapterId;

  _VerseListState(this.routeBus, this.chapterId);

  var dataList = new List<Map<String, dynamic>>();

  @override
  void initState() {
    routeBus.dbf.then((db) {
      db
          .rawQuery(
              "SELECT verse_id, text  FROM verse WHERE chapter_id=$chapterId;")
          .then((value) {
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
        routeBus: routeBus,
        title: Translations.of(context).text("verses"),
        appBar: AppBar(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 2),
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            var itemValue = dataList[index].values;
            return new Card(
              margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              elevation: 1,
              child: new InkWell(
                onLongPress: () {
                  Clipboard.setData(new ClipboardData(
                      text:
                          '${itemValue.last} - ${Translations.of(context).text("psalm")} $chapterId:${itemValue.first}'));
                  Fluttertoast.showToast(
                      msg:
                          "${Translations.of(context).text("copied_psalm")} $chapterId:${itemValue.first}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: ListTile(
                  title: Text('${itemValue.first}. ${itemValue.last}'),
                ),
              ),
//                color: Colors.transparent,
            );
          },
        ),
      ),
    );
  }
}
