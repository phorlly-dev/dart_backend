// import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../services/db_request.dart';

part 'task_response.g.dart';
part 'extension_task.dart';

@JsonSerializable()
// @CopyWith()
class TaskResponse implements IModel {
  // @CopyWithField(immutable: true)
  final int? id;
  final String name;
  final String? note, attachments;

  @JsonKey(name: 'due_date')
  final String dueDate;

  @JsonKey(name: 'started_at')
  final String startedAt;

  @JsonKey(name: 'ended_at')
  final String endedAt;

  @JsonKey(name: 'assigned_to')
  final int assignedTo;

  @JsonKey(name: 'status')
  final Status status;

  @JsonKey(name: 'priority')
  final Priority priority;

  /// Stored in DB as INTEGER ARGB
  @JsonKey(fromJson: _colorFromInt, toJson: _colorToInt)
  final Color color;

  @JsonKey(name: 'created_at')
  final String createdAt; // full timestamp

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  TaskResponse({
    required this.name,
    this.note,
    this.attachments,
    required this.dueDate,
    required this.startedAt,
    required this.endedAt,
    required this.assignedTo,
    this.status = Status.pending,
    this.priority = Priority.low,
    this.color = const Color(0xFF2196F3),
    this.id,

    // these will be filled by the DB defaults
    String? createdAt,
    String? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  TaskResponse copyWith({
    int? id,
    String? name,
    Color? color,
    Status? status,
    Priority? priority,
    String? note,
    String? attachments,
    String? dueDate,
    String? startedAt,
    String? endedAt,
    int? assignedTo,
    String? createdAt,
    String? updatedAt,
  }) {
    return TaskResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      note: note ?? this.note,
      attachments: attachments ?? this.attachments,
      color: color ?? this.color,
      priority: priority ?? this.priority,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // json_serializable
  factory TaskResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TaskResponseToJson(this);

  /// sqflite uses 0/1 for booleans
  @override
  TaskResponse fromMap(Map<String, dynamic> map) => TaskResponse(
        id: map['id'] as int?,
        name: map['name'] as String,
        note: map['note'] as String?,
        dueDate: map['due_date'] as String,
        attachments: map['attachments'] as String?,
        assignedTo: map['assigned_to'] as int,
        color: Color((map['color'] as int)),
        status: StatusX.fromCode(map['status'] as int),
        priority: PriorityX.fromCode(map['priority'] as int),
        startedAt: map['started_at'] as String,
        endedAt: map['ended_at'] as String,
        createdAt: map['created_at'] as String,
        updatedAt: map['updated_at'] as String,
      );

  @override
  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'note': note,
        'due_date': dueDate,
        'attachments': attachments,
        'assigned_to': assignedTo,
        'started_at': startedAt,
        'ended_at': endedAt,
        'status': status.code,
        'priority': priority.code,
        'color': color.toARGB32(),
      };

  // helpers for json <-> Color
  static Color _colorFromInt(int i) => Color(i);
  static int _colorToInt(Color c) => c.toARGB32();
}
