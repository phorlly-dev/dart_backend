// import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dart_backend/utils/index.dart';
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

  @JsonKey(name: 'due_date', fromJson: strToDt, toJson: dtToStr)
  final DateTime dueDate;

  @JsonKey(name: 'started_at', fromJson: strToDt, toJson: dtToStr)
  final DateTime startedAt;

  @JsonKey(name: 'ended_at', fromJson: strToDt, toJson: dtToStr)
  final DateTime endedAt;

  @JsonKey(name: 'assigned_to')
  final int assignedTo;

  @JsonKey(name: 'status')
  final Status status;

  @JsonKey(name: 'priority')
  final Priority priority;

  /// Stored in DB as INTEGER ARGB
  @JsonKey(fromJson: colorFromInt, toJson: colorToInt)
  final Color color;

  @JsonKey(name: 'created_at', fromJson: strToDt, toJson: dtToStr)
  final DateTime createdAt; // full timestamp

  @JsonKey(name: 'updated_at', fromJson: strToDt, toJson: dtToStr)
  final DateTime updatedAt;

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
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? dtNow(),
        updatedAt = updatedAt ?? dtNow();

  TaskResponse copyWith({
    int? id,
    String? name,
    Color? color,
    Status? status,
    Priority? priority,
    String? note,
    String? attachments,
    DateTime? dueDate,
    DateTime? startedAt,
    DateTime? endedAt,
    int? assignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
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

  factory TaskResponse.formData(Map<String, dynamic> form) => TaskResponse(
        id: form['id'] as int?,
        name: form['name'] as String,
        note: form['note'] as String?,
        dueDate: strToDt(form['due_date'] as String),
        attachments: form['attachments'] as String?,
        assignedTo: form['assigned_to'] as int,
        color: Color((form['color'] as int)),
        status: StatusX.fromCode(form['status'] as int),
        priority: PriorityX.fromCode(form['priority'] as int),
        startedAt: strToDt(form['started_at'] as String),
        endedAt: strToDt(form['ended_at'] as String),
        createdAt: parseOrNow(form['created_at'] as String),
        updatedAt: parseOrNow(form['updated_at'] as String),
      );

  /// sqflite uses 0/1 for booleans
  @override
  TaskResponse fromMap(Map<String, dynamic> map) => TaskResponse(
        id: map['id'] as int?,
        name: map['name'] as String,
        note: map['note'] as String?,
        dueDate: strToDt(map['due_date'] as String),
        attachments: map['attachments'] as String?,
        assignedTo: map['assigned_to'] as int,
        color: Color((map['color'] as int)),
        status: StatusX.fromCode(map['status'] as int),
        priority: PriorityX.fromCode(map['priority'] as int),
        startedAt: strToDt(map['started_at'] as String),
        endedAt: strToDt(map['ended_at'] as String),
        createdAt: parseOrNow(map['created_at'] as String),
        updatedAt: parseOrNow(map['updated_at'] as String),
      );

  @override
  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'note': note,
        'due_date': dueDate.toIso8601String(),
        'attachments': attachments,
        'assigned_to': assignedTo,
        'started_at': startedAt.toIso8601String(),
        'ended_at': endedAt.toIso8601String(),
        'status': status.code,
        'priority': priority.code,
        'color': color.toARGB32(),
      };
}
