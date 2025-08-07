// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventResponse _$EventResponseFromJson(Map<String, dynamic> json) =>
    EventResponse(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      note: json['note'] as String?,
      repeatRule:
          $enumDecodeNullable(_$RepeatRuleEnumMap, json['repeat_rule']) ??
              RepeatRule.none,
      color: json['color'] == null
          ? const Color(0xFF2196F3)
          : colorFromInt((json['color'] as num).toInt()),
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']) ??
          Status.pending,
      remindMin: (json['remind_min'] as num?)?.toInt() ?? 5,
      eventDate: strToDt(json['event_date'] as String),
      startTime: strToDt(json['start_time'] as String),
      endTime: strToDt(json['end_time'] as String),
      createdAt: strToDt(json['created_at'] as String),
      updatedAt: strToDt(json['updated_at'] as String),
    );

Map<String, dynamic> _$EventResponseToJson(EventResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'note': instance.note,
      'repeat_rule': _$RepeatRuleEnumMap[instance.repeatRule]!,
      'color': colorToInt(instance.color),
      'status': _$StatusEnumMap[instance.status]!,
      'remind_min': instance.remindMin,
      'event_date': dtToStr(instance.eventDate),
      'start_time': dtToStr(instance.startTime),
      'end_time': dtToStr(instance.endTime),
      'created_at': dtToStr(instance.createdAt),
      'updated_at': dtToStr(instance.updatedAt),
    };

const _$RepeatRuleEnumMap = {
  RepeatRule.none: 'none',
  RepeatRule.daily: 'daily',
  RepeatRule.weekly: 'weekly',
  RepeatRule.monthly: 'monthly',
};

const _$StatusEnumMap = {
  Status.pending: 'pending',
  Status.loading: 'loading',
  Status.completed: 'completed',
  Status.canceled: 'canceled',
};
