import 'package:dart_backend/models/event_response.dart';
import 'db_request.dart';

class EventRequest extends DbRequest<EventResponse> {
  @override
  String get tableName => 'events';

  @override //'CREATE_EVENTS_TABLE'
  String get createTableSql => '';

  @override
  EventResponse get blankModel =>
      EventResponse(title: '', eventDate: '', startTime: '', endTime: '');
}
