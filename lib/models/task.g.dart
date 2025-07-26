// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['title']);
  return Task(
    id: (json['id'] as num?)?.toInt(),
    title: json['title'] as String,
    done: (json['done'] as int) == 1,
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  if (instance.id != null) 'id': instance.id,
  'id': instance.id,
  'title': instance.title,
  'done': instance.done ? 1 : 0,
};
