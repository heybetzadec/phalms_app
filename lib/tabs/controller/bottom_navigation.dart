import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phalmsapp/help/const.dart';
import 'package:phalmsapp/help/route_bus.dart';
import 'package:phalmsapp/help/translations.dart';

enum TabItem { chapter, words, theme, names, other }

Map<TabItem, String> tabName = {
  TabItem.chapter: 'Surələr',
  TabItem.words: 'Words',
  TabItem.theme: 'Theme',
  TabItem.names: 'Names',
  TabItem.other: 'Other',
};

Map<TabItem, IconData> tabIcons = {
  TabItem.chapter: FontAwesomeIcons.bookOpen,
  TabItem.words: FontAwesomeIcons.tag,
  TabItem.theme: FontAwesomeIcons.inbox,
  TabItem.names: FontAwesomeIcons.bookmark,
  TabItem.other: FontAwesomeIcons.cog,
};

class BottomNavigation extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final RouteBus routeBus;

  const BottomNavigation({
    Key key,
    this.currentTab,
    this.onSelectTab,
    this.routeBus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    tabName = {
      TabItem.chapter: Translations.of(context).text("psalms"),
      TabItem.words: Translations.of(context).text("word"),
      TabItem.theme: Translations.of(context).text("theme"),
      TabItem.names: Translations.of(context).text("doc"),
      TabItem.other: Translations.of(context).text("other"),
    };

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(tabItem: TabItem.chapter),
        _buildItem(tabItem: TabItem.words),
        _buildItem(tabItem: TabItem.theme),
        _buildItem(tabItem: TabItem.names),
        _buildItem(tabItem: TabItem.other),
      ],
      onTap: (index) {
        onSelectTab(
          TabItem.values[index],
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem({TabItem tabItem}) {
    String text = tabName[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        tabIcons[tabItem],
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
    );
  }

  Color _colorTabMatching({TabItem item}) {
    return currentTab == item ? Colors.teal : Colors.black54;
  }
}
