// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: (json['id'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      remind: (json['remind'] as num?)?.toInt(),
      title: json['title'] as String?,
      note: json['note'] as String?,
      repeat: json['repeat'] as String?,
      color: json['color'] as String?,
      date: json['date'] as String?,
      startedAt: json['started_at'] as String?,
      endedAt: json['ended_at'] as String?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'remind': instance.remind,
      'title': instance.title,
      'note': instance.note,
      'date': instance.date,
      'repeat': instance.repeat,
      'color': instance.color,
      'started_at': instance.startedAt,
      'ended_at': instance.endedAt,
    };
