import 'package:flutter/material.dart';
import 'package:phalmsapp/help/base_app_bar.dart';
import 'package:phalmsapp/help/route_bus.dart';

class VersesByWord extends StatefulWidget {
  final RouteBus routeBus;
  final int chapterId;
  final int verseId;

  VersesByWord({Key key, this.routeBus, this.chapterId, this.verseId}) : super(key: key);

  @override
  _VersesByWordState createState() => _VersesByWordState(routeBus, chapterId, verseId);
}

class _VersesByWordState extends State<VersesByWord> {
  final RouteBus routeBus;
  final int chapretId;
  final int verseId;

  _VersesByWordState(this.routeBus, this.chapretId, this.verseId);

  var dataList = new List<Map<String, dynamic>>();

  @override
  void initState() {
    routeBus.dbf.then((db) {
      db
          .rawQuery(
          "SELECT verse_id, text  FROM verse WHERE chapter_id=$chapretId;")
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
        title: 'Sura',
        appBar: AppBar(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 2),
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            var itemValue = dataList[index].values.toList();
            return new Card(
              margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              elevation: 1,
              child: new InkWell(
                onTap: () {
                  print('on tap');
                },
                child: ListTile(
                  title: Text('${itemValue.first}. ${itemValue.last}'),
                ),
              ),
            );
          },
        ),
      ),
    );

  }
}
