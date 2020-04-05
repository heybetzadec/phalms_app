import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:phalmsapp/help/event_key.dart';
import 'package:phalmsapp/help/route_bus.dart';
import 'package:phalmsapp/tabs/controller/bottom_navigation.dart';
import 'package:phalmsapp/tabs/controller/tab_navigator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  TabItem _currentTab = TabItem.chapter;
  EventBus eventBus = new EventBus();
  RouteBus routeBus;

  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.chapter: GlobalKey<NavigatorState>(),
    TabItem.words: GlobalKey<NavigatorState>(),
    TabItem.theme: GlobalKey<NavigatorState>(),
    TabItem.names: GlobalKey<NavigatorState>(),
    TabItem.other: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    var dbf = getDatabase();
    routeBus = new RouteBus(
        eventBus: eventBus,
        dbf: dbf,
      languageId: 1,
      translationId: 121,
      languageCode: 'az'
    );
    super.initState();
  }


  void _selectTab(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.chapter:
        {
          eventBus.fire(ChapterClickEvent('event'));
        }
        break;
      case TabItem.words:
        {
          eventBus.fire(LetterClickEvent('event'));
        }
        break;
      case TabItem.theme:
        {
          eventBus.fire(ThemeClickEvent('event'));
        }
        break;
      case TabItem.names:
        {
          eventBus.fire(NameClickEvent('event'));
        }
        break;
      case TabItem.other:
        {
          eventBus.fire(OtherClickEvent('event'));
        }
        break;
      default:
        {
          eventBus.fire(ChapterClickEvent('event'));
        }
        break;
    }

    if (tabItem == _currentTab) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.chapter) {
            // select 'main' tab
            _selectTab(TabItem.chapter);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.chapter),
          _buildOffstageNavigator(TabItem.words),
          _buildOffstageNavigator(TabItem.theme),
          _buildOffstageNavigator(TabItem.names),
          _buildOffstageNavigator(TabItem.other),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
          routeBus: routeBus,
        ),
      ),
    );
  }

  Future<Database> getDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "phalms_data.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "phalms_data.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    } else {
      print("Opening existing database");
    }
    // open the database
    var db = await openDatabase(path, readOnly: true);
//    db.execute('PRAGMA encoding = "UTF-8";');

    return db;
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        routeBus:routeBus,
        tabItem: tabItem,
      ),
    );
  }


}
