// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      note: json['note'] as String?,
      repeatRule: json['repeat_rule'] as String?,
      color: json['color'] == null
          ? const Color(0xFF2196F3)
          : Event._colorFromInt((json['color'] as num).toInt()),
      status: $enumDecodeNullable(_$EventStatusEnumMap, json['status']) ??
          EventStatus.pending,
      remindMin: (json['remind_min'] as num?)?.toInt() ?? 0,
      eventDate: json['event_date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'note': instance.note,
      'repeat_rule': instance.repeatRule,
      'color': Event._colorToInt(instance.color),
      'status': _$EventStatusEnumMap[instance.status]!,
      'remind_min': instance.remindMin,
      'event_date': instance.eventDate,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

const _$EventStatusEnumMap = {
  EventStatus.pending: 'pending',
  EventStatus.loading: 'loading',
  EventStatus.completed: 'completed',
  EventStatus.canceled: 'canceled',
};
