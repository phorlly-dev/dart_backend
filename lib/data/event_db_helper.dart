import 'package:dart_backend/models/event.dart';
import 'generic_db_helper.dart';

class EventDbHelper extends GenericDbHelper<Event> {
  @override
  String get tableName => 'events';

  @override //'CREATE_EVENTS_TABLE'
  String get createTableSql => '''CREATE TABLE events (
        id  INTEGER PRIMARY KEY AUTOINCREMENT,

        title TEXT NOT NULL,
        note TEXT NULL,

        -- repetition rule, e.g. "daily", "weekly", or cron-style
        repeat_rule TEXT NULL,      

        -- store as ARGB int (e.g. 0xFF3366CC), not a string
        color INTEGER NOT NULL DEFAULT 0xFF2196F3, 

        -- 0 = pending, 1 = loading, 2 = completed, 3 = canceled 
        status INTEGER NOT NULL DEFAULT 0 CHECK(status IN (0,1,2,3)),  

        -- minutes before event to remind
        remind_min INTEGER NOT NULL DEFAULT 5,      

        -- the “calendar” date of the event, YYYY-MM-DD
        event_date TEXT NOT NULL,  
        -- start/end timestamps in full ISO-8601
        start_time TEXT  NOT NULL,
        end_time TEXT NOT NULL,

        -- audit fields
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT  NOT NULL DEFAULT CURRENT_TIMESTAMP
      );

  -- index for fast date lookups
   CREATE INDEX idx_events_event_date ON events(event_date);''';

  @override
  Event get blankModel =>
      Event(title: '', eventDate: '', startTime: '', endTime: '');
}
