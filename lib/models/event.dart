import 'package:dart_backend/data/generic_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

/// Mirror the SQL CHECK(status IN (0,1,2,3))
enum EventStatus { pending, loading, completed, canceled }

extension EventStatusX on EventStatus {
  int get code {
    switch (this) {
      case EventStatus.pending:
        return 0;
      case EventStatus.loading:
        return 1;
      case EventStatus.completed:
        return 2;
      case EventStatus.canceled:
        return 3;
    }
  }

  String get label {
    switch (this) {
      case EventStatus.pending:
        return 'Pending...';
      case EventStatus.loading:
        return 'Loading...';
      case EventStatus.completed:
        return 'Completed..!';
      case EventStatus.canceled:
        return 'Canceled..!';
    }
  }

  static EventStatus fromCode(int code) {
    return EventStatus.values.firstWhere((e) => e.code == code);
  }
}

@JsonSerializable()
class Event implements DbModel {
  final int? id;
  final String title;
  final String? note;
  @JsonKey(name: 'repeat_rule')
  final String? repeatRule;

  /// Stored in DB as INTEGER ARGB
  @JsonKey(fromJson: _colorFromInt, toJson: _colorToInt)
  final Color color;

  /// Stored in DB as INTEGER
  @JsonKey(name: 'status')
  final EventStatus status;
  @JsonKey(name: 'remind_min')
  final int remindMin;
  @JsonKey(name: 'event_date')
  final String eventDate; // YYYY-MM-DD
  @JsonKey(name: 'start_time')
  final String startTime; // ISO-8601 or "HH:mm"
  @JsonKey(name: 'end_time')
  final String endTime;
  @JsonKey(name: 'created_at')
  final String createdAt; // full timestamp
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Event({
    this.id,
    required this.title,
    this.note,
    this.repeatRule,
    this.color = const Color(0xFF2196F3),
    this.status = EventStatus.pending,
    this.remindMin = 0,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    // these will be filled by the DB defaults
    String? createdAt,
    String? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  /// copyWith for easy updates
  Event copyWith({
    int? id,
    String? title,
    String? note,
    String? repeatRule,
    Color? color,
    EventStatus? status,
    int? remindMin,
    String? eventDate,
    String? startTime,
    String? endTime,
    String? createdAt,
    String? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      repeatRule: repeatRule ?? this.repeatRule,
      color: color ?? this.color,
      status: status ?? this.status,
      remindMin: remindMin ?? this.remindMin,
      eventDate: eventDate ?? this.eventDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// json_serializable boilerplate
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);

  /// DbModel: build from a DB row
  @override
  Event fromMap(Map<String, dynamic> m) => Event(
        id: m['id'] as int?,
        title: m['title'] as String,
        note: m['note'] as String?,
        repeatRule: m['repeat_rule'] as String?,
        color: Color((m['color'] as int)),
        status: EventStatusX.fromCode(m['status'] as int),
        remindMin: m['remind_min'] as int,
        eventDate: m['event_date'] as String,
        startTime: m['start_time'] as String,
        endTime: m['end_time'] as String,
        createdAt: m['created_at'] as String,
        updatedAt: m['updated_at'] as String,
      );

  /// DbModel: convert to a map for inserts/updates
  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'note': note,
      'repeat_rule': repeatRule,
      'color': color.toARGB32(),
      'status': status.code,
      'remind_min': remindMin,
      'event_date': eventDate,
      'start_time': startTime,
      'end_time': endTime,
      // let SQLite use DEFAULT CURRENT_TIMESTAMP on create/update
    };
    if (id != null) map['id'] = id;

    return map;
  }

  // helpers for json <-> Color
  static Color _colorFromInt(int i) => Color(i);
  static int _colorToInt(Color c) => c.toARGB32();
}
