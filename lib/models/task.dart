// lib/models/task.dart
import 'package:json_annotation/json_annotation.dart';
import '../data/generic_db_helper.dart';

part 'task.g.dart';

@JsonSerializable()
class Task implements DbModel {
  final int? id;
  final String title;
  final bool done;

  Task({this.id, required this.title, this.done = false});

  Task copyWith({int? id, String? title, bool? done}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  // json_serializable
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  /// sqflite uses 0/1 for booleans
  @override
  Task fromMap(Map<String, dynamic> map) => Task(
    id: map['id'] as int?,
    title: map['title'] as String,
    done: (map['done'] as int) == 1,
  );

  @override
  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'done': done ? 1 : 0,
  };
}
