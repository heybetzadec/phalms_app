import 'package:event_bus/event_bus.dart';
import 'package:sqflite/sqflite.dart';

class RouteBus {
  final EventBus eventBus;
  final  Future<Database> dbf;
  int languageId;
  int translationId;
  String languageCode;

  RouteBus({
    this.eventBus,
    this.dbf,
    this.languageId,
    this.translationId,
    this.languageCode,
  });
}
