import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:phalmsapp/help/base_app_bar.dart';
import 'package:phalmsapp/help/const.dart';
import 'package:phalmsapp/help/event_key.dart';
import 'package:phalmsapp/help/route_bus.dart';
import 'package:phalmsapp/help/translations.dart';
import 'package:phalmsapp/tabs/tab1/verse_list.dart';
import 'package:tinycolor/tinycolor.dart';

class ChapterList extends StatefulWidget {
  final RouteBus routeBus;

  ChapterList({Key key, this.routeBus}) : super(key: key);

  @override
  _ChapterListState createState() => _ChapterListState(routeBus);
}

class _ChapterListState extends State<ChapterList> {
  final RouteBus routeBus;

  _ChapterListState(this.routeBus);

  var dataList = new List<Map<String, dynamic>>();
  var searchList = new List<Map<String, dynamic>>();
  var translate = new Map<dynamic, dynamic>();
  FocusNode searchFocusNode;
  TextEditingController searchController = new TextEditingController();
  bool searchFocus = false;
  ScrollController scrollController;

  @override
  void initState() {
    searchFocusNode = FocusNode();
    scrollController = ScrollController();

    routeBus.dbf.then((db) {
      db
          .rawQuery("SELECT chapter_id  FROM verse GROUP BY chapter_id; ")
          .then((value) {
        setState(() {
          dataList = value.toList();
          searchList = dataList;
        });
      });
    });

    routeBus.eventBus.on<ChapterClickEvent>().listen((event) {
      searchFocusNode.unfocus();
      searchController.clear();
      setState(() {
        searchList = dataList;
      });
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          searchFocusNode.unfocus();
          searchFocus = false;
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    searchFocusNode.addListener(() {
      setState(() {
        searchFocus = searchFocusNode.hasFocus;
      });
    });

    return Scaffold(
      appBar: BaseAppBar(
        title: Translations.of(context).text("psalms"),
        appBar: AppBar(),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            flexibleSpace: Container(
              margin: EdgeInsets.only(
                top: 4,
              ),
              child: TextField(
                controller: searchController,
                autofocus: false,
                autocorrect: false,
                textInputAction: TextInputAction.search,
                focusNode: searchFocusNode,
                onChanged: (value) {
                  var searched = new List<Map<String, dynamic>>();
                  setState(() {
                    searched.addAll(dataList.where((element) {
                      String item =
                          element.values.last.toString().toLowerCase();
                      value = value
                          .toLowerCase()
                          .replaceAll("[^0-9.]", "")
                          .replaceAll(new RegExp('[^0-9.]'), '');
                      print(value);
                      return item.contains(value);
                    }));
                  });
                  setState(() {
                    searchList = searched;
                  });
                },
                decoration: InputDecoration(
                    hintText: Translations.of(context).text("page_search"),
                    contentPadding: EdgeInsets.all(15),
                    suffixIcon: getSearchSuffix(searchFocus),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    fillColor: Colors.red),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var itemValue = searchList[index].values;
                return new Card(
                  margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  elevation: 1,
                  child: new InkWell(
                    onTap: () {
                      searchFocusNode.unfocus();
                      Navigator.of(context).push(Const.customRoute((context) {
                        return VerseList(
                          routeBus: routeBus,
                          chapterId: itemValue.first,
                        );
                      })).then((value) {
                        searchController.clear();
                        setState(() {
                          searchList = dataList;
                        });
                      });
                    },
                    child: ListTile(
                      title: Text(
                        '${Translations.of(context).text("psalm")} ${itemValue.first}',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ),
                  ),
                );
              },
              childCount: searchList.length,
            ),
          ),
        ],
      ),
    );
  }

  getSearchSuffix(bool isFocus) {
    if (isFocus) {
      return IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (searchController.text.length == 0) {
              searchFocusNode.unfocus();
            } else {
              searchController.clear();
            }
            setState(() {
              searchList = dataList;
            });
          });
    } else {
      return Icon(
        Icons.list,
        size: 30,
        color: Colors.black26,
      );
    }
  }
}
