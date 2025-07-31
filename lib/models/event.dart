import 'package:dart_backend/data/generic_db_helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event implements DbModel {
  final int? id, status, remind;
  final String? title, note, date, repeat, color;
  @JsonKey(name: 'started_at')
  final String? startedAt;

  @JsonKey(name: 'ended_at')
  final String? endedAt;

  Event({
    this.id,
    this.status,
    this.remind,
    this.title,
    this.note,
    this.repeat,
    this.color,
    this.date,
    this.startedAt,
    this.endedAt,
  });

  Event copyWith({
    int? id,
    String? title,
    String? note,
    int? status,
    int? remind,
    String? repeat,
    String? color,
    String? date,
    String? startedAt,
    String? endedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      status: status ?? this.status,
      remind: remind ?? this.remind,
      repeat: repeat ?? this.repeat,
      color: color ?? this.color,
      date: date ?? this.date,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  @override
  DbModel fromMap(Map<String, dynamic> map) => _$EventFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$EventToJson(this);
}
