import '../models/task.dart';
import 'generic_db_helper.dart';

class TaskDbHelper extends GenericDbHelper<Task> {
  @override
  String get tableName => 'tasks';

  @override
  String get createTableSql => 'CREATE_TASKS_TABLE';

  @override
  Task get blankModel => Task(title: '', done: false);
}
