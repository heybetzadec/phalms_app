import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:phalmsapp/help/const.dart';
import 'package:phalmsapp/help/event_key.dart';
import 'package:phalmsapp/help/translations.dart';
import 'package:phalmsapp/help/locale_util.dart';
import 'package:phalmsapp/tabs/controller/app.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(Main());
}


class Main extends StatefulWidget {

  Main({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MainState state =
    context.findAncestorStateOfType<_MainState>();
    state.changeLanguage(newLocale);
  }

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Locale _locale = Locale('en');

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  _MainState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _locale,//Locale('az'),
      supportedLocales: localeUtil.supportedLocales(),
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        return locale;
      },
      theme: ThemeData(
        primarySwatch: Const.primaryColor,
      ),
      home: App(),
    );
  }
}
