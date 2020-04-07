import 'package:flutter/material.dart';
import 'package:phalmsapp/help/route_bus.dart';
import 'package:phalmsapp/tabs/controller/bottom_navigation.dart';
import 'package:phalmsapp/tabs/controller/for_route.dart';
import 'package:phalmsapp/tabs/tab1/chapter_list.dart';
import 'package:phalmsapp/tabs/tab2/letter_list.dart';
import 'package:phalmsapp/tabs/tab3/theme_list.dart';
import 'package:phalmsapp/tabs/tab4/name_list.dart';
import 'package:phalmsapp/tabs/tab5/other.dart';

class TabPages extends StatelessWidget {
  final String title;
  final ValueChanged<ForRoute> onPush;
  final TabItem tabItem;
  final RouteBus routeBus;

  TabPages({this.title, this.onPush, this.tabItem, this.routeBus});

  Widget widgetTab;

  @override
  Widget build(BuildContext context) {
    switch (tabItem) {
      case TabItem.chapter:
        {
          widgetTab = ChapterList(
            routeBus: routeBus,
          );
        }
        break;
      case TabItem.words:
        {
          widgetTab = LetterList(
            routeBus: routeBus,
          );
        }
        break;
      case TabItem.theme:
        {
          widgetTab = ThemeList(
            routeBus: routeBus,
          );
        }
        break;
      case TabItem.names:
        {
          widgetTab = NameList(
            routeBus: routeBus,
          );
        }
        break;
      case TabItem.other:
        {
          widgetTab = Other(
            routeBus: routeBus,
          );
        }
        break;
      default:
        {
          widgetTab = ChapterList(
            routeBus: routeBus,
          );
        }
        break;
    }
    return Scaffold(body: widgetTab);
  }
}
