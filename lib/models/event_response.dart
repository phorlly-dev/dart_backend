// import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dart_backend/services/db_request.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_response.g.dart';
part 'extension_event.dart';

@JsonSerializable()
// @CopyWith()
class EventResponse implements IModel {
  // @CopyWithField(immutable: true)
  final int? id;
  final String title;
  final String? note;

  @JsonKey(name: 'repeat_rule')
  final RepeatRule repeatRule;

  /// Stored in DB as INTEGER ARGB
  @JsonKey(name: 'color', fromJson: colorFromInt, toJson: colorToInt)
  final Color color;

  /// Stored in DB as INTEGER
  @JsonKey(name: 'status')
  final Status status;

  @JsonKey(name: 'remind_min')
  final int remindMin;

  @JsonKey(name: 'event_date', fromJson: strToDt, toJson: dtToStr)
  final DateTime eventDate; // YYYY-MM-DD

  @JsonKey(name: 'start_time', fromJson: strToDt, toJson: dtToStr)
  final DateTime startTime; // ISO-8601 or "HH:mm"

  @JsonKey(name: 'end_time', fromJson: strToDt, toJson: dtToStr)
  final DateTime endTime;

  @JsonKey(name: 'created_at', fromJson: strToDt, toJson: dtToStr)
  final DateTime createdAt; // full timestamp

  @JsonKey(name: 'updated_at', fromJson: strToDt, toJson: dtToStr)
  final DateTime updatedAt;

  EventResponse({
    this.id,
    required this.title,
    this.note,
    this.repeatRule = RepeatRule.none,
    this.color = const Color(0xFF2196F3),
    this.status = Status.pending,
    this.remindMin = 5,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    // these will be filled by the DB defaults
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? dtNow(),
        updatedAt = updatedAt ?? dtNow();

  /// copyWith for easy updates
  EventResponse copyWith({
    int? id,
    String? title,
    String? note,
    RepeatRule? repeatRule,
    Color? color,
    Status? status,
    int? remindMin,
    DateTime? eventDate,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventResponse(
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
  factory EventResponse.fromJson(Map<String, dynamic> json) =>
      _$EventResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EventResponseToJson(this);

  /// DbModel: build from a DB row
  @override
  EventResponse fromMap(Map<String, dynamic> m) => EventResponse(
        id: m['id'] as int?,
        title: m['title'] as String,
        note: m['note'] as String?,
        repeatRule: RepeatRuleX.fromCode(m['repeat_rule'] as int),
        color: Color((m['color'] as int)),
        status: StatusX.fromCode(m['status'] as int),
        remindMin: m['remind_min'] as int,
        eventDate: strToDt(m['event_date'] as String),
        startTime: strToDt(m['start_time'] as String),
        endTime: strToDt(m['end_time'] as String),
        createdAt: strToDt(m['created_at'] as String),
        updatedAt: strToDt(m['updated_at'] as String),
      );

  /// DbModel: convert to a map for inserts/updates
  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'note': note,
      'repeat_rule': repeatRule.code,
      'color': color.toARGB32(),
      'status': status.code,
      'remind_min': remindMin,
      'event_date': eventDate.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      // let SQLite use DEFAULT CURRENT_TIMESTAMP on create/update
    };
    if (id != null) map['id'] = id;

    return map;
  }
}
