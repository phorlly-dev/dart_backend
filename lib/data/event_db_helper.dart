import 'package:dart_backend/models/event.dart';
import 'generic_db_helper.dart';

class EventDbHelper extends GenericDbHelper<Event> {
  @override
  String get tableName => 'envents';

  @override
  String get createTableSql => 'CREATE_EVENTS_TABLE';

  @override
  Event get blankModel => Event();
}
