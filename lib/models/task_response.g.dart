// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskResponse _$TaskResponseFromJson(Map<String, dynamic> json) => TaskResponse(
      name: json['name'] as String,
      note: json['note'] as String?,
      attachments: json['attachments'] as String?,
      dueDate: strToDt(json['due_date'] as String),
      startedAt: strToDt(json['started_at'] as String),
      endedAt: strToDt(json['ended_at'] as String),
      assignedTo: (json['assigned_to'] as num).toInt(),
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']) ??
          Status.pending,
      priority: $enumDecodeNullable(_$PriorityEnumMap, json['priority']) ??
          Priority.low,
      color: json['color'] == null
          ? const Color(0xFF2196F3)
          : colorFromInt((json['color'] as num).toInt()),
      id: (json['id'] as num?)?.toInt(),
      createdAt: strToDt(json['created_at'] as String),
      updatedAt: strToDt(json['updated_at'] as String),
    );

Map<String, dynamic> _$TaskResponseToJson(TaskResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'note': instance.note,
      'attachments': instance.attachments,
      'due_date': dtToStr(instance.dueDate),
      'started_at': dtToStr(instance.startedAt),
      'ended_at': dtToStr(instance.endedAt),
      'assigned_to': instance.assignedTo,
      'status': _$StatusEnumMap[instance.status]!,
      'priority': _$PriorityEnumMap[instance.priority]!,
      'color': colorToInt(instance.color),
      'created_at': dtToStr(instance.createdAt),
      'updated_at': dtToStr(instance.updatedAt),
    };

const _$StatusEnumMap = {
  Status.pending: 'pending',
  Status.inProgress: 'inProgress',
  Status.completed: 'completed',
  Status.failed: 'failed',
};

const _$PriorityEnumMap = {
  Priority.low: 'low',
  Priority.medium: 'medium',
  Priority.high: 'high',
};
