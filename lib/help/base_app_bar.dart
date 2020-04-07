import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final AppBar appBar;

  BaseAppBar({Key key, this.title, this.appBar}) : super(key: key);

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  _BaseAppBarState createState() => _BaseAppBarState(title, appBar);
}

class _BaseAppBarState extends State<BaseAppBar> {
  final String title;
  final AppBar appBar;

  _BaseAppBarState(this.title, this.appBar);

  final List<String> city_names = [
    "Aberdeen",
    "classAurora",
    "Austin",
    "Bakersfield",
    "York",
    "Youngstown"
  ];

  String query = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.search,
            size: 35,
          ),
          onPressed: () async {
            final String selected = await showSearch(
                context: context, delegate: _MySearchDelegate(city_names));

            if (selected != null && selected != query) {
              setState(() {
                query = selected;
              });
            }
          },
        )
      ],
    );
  }
}

class _MySearchDelegate extends SearchDelegate<String> {
  final List<String> city_names;

  final List<String> _history = [
    "Aurora",
    "Austin",
    "Bakersfield",
    "Baltimore",
    "Barnstable",
    "Baton Rouge",
    "Beaumont",
    "Bel Air",
    "Bellevue",
    "Berkeley",
    "Bethlehem"
  ];

  List<String> filterName = new List();

  _MySearchDelegate(this.city_names);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: const Icon((Icons.clear)),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? _history
        : city_names.where((c) => c.toLowerCase().contains(query)).toList();

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (BuildContext context, int index) {
          return new ListTile(
            title: Text(suggestions[index]),
            onTap: () {
//              showResults(context);
              close(context, suggestions[index]);
            },
          );
        });
  }
}
