import 'package:dart_backend/utils/index.dart';

import '../models/task_response.dart';
import 'db_request.dart';

class TaskRequest extends DbRequest<TaskResponse> {
  @override
  String get tableName => 'tasks';

  @override //'CREATE_TASKS_TABLE'
  String get createTableSql => '';

  @override
  TaskResponse get blankModel => TaskResponse(
      name: '',
      dueDate: dtNow(),
      startedAt: dtNow(),
      endedAt: dtNow(),
      assignedTo: 0);
}
