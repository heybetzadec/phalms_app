import 'package:flutter/material.dart';
import 'package:phalmsapp/help/base_app_bar.dart';
import 'package:phalmsapp/help/const.dart';
import 'package:phalmsapp/help/route_bus.dart';
import 'package:phalmsapp/tabs/tab2/verses_by_word.dart';

class WordList extends StatefulWidget {
  final RouteBus routeBus;
  final int letterId;

  WordList({Key key, this.routeBus, this.letterId}) : super(key: key);

  @override
  _WordListState createState() => _WordListState(routeBus, letterId);
}

class _WordListState extends State<WordList> {
  final RouteBus routeBus;
  final int letterId;

  _WordListState(this.routeBus, this.letterId);

  var dataList = new List<Map<String, dynamic>>();

  @override
  void initState() {
    routeBus.dbf.then((db) {
      db
          .rawQuery(
          "SELECT firstline_id, firstline_name, chapter_id, verse_id  FROM firstline WHERE letter_id = $letterId;")
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
                  Navigator.of(context).push(
                      Const.customRoute((context) {
                        return VersesByWord(
                          routeBus: routeBus,
                          chapterId: itemValue[2],
                          verseId: itemValue[3],
                        );
                      })
                  );
                },
                child: ListTile(
                  title: Text('${itemValue[0]}. ${itemValue[1]} Paslm ${itemValue[2]}${!itemValue[3].toString().isEmpty ? ":"+itemValue[3].toString() : ""}'),
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
