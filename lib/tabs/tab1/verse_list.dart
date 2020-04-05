import 'package:flutter/material.dart';
import 'package:phalmsapp/help/base_app_bar.dart';
import 'package:phalmsapp/help/route_bus.dart';
import 'package:phalmsapp/tabs/controller/anchored_overlay.dart';
import 'package:phalmsapp/tabs/controller/fab_withIcons.dart';

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
        title: 'Sura',
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
                onTap: () {
                  print('on tap');
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
      floatingActionButton: _buildFab(context)
    );
  }


  Widget _buildFab(BuildContext context) {
    final icons = [ Icons.sms, Icons.mail, Icons.phone ];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: (value){
              print('tapped $value');
            },
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () { },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }

}
