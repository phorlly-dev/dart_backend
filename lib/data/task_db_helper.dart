import '../models/task.dart';
import 'generic_db_helper.dart';

class TaskDbHelper extends GenericDbHelper<Task> {
  @override
  String get tableName => 'tasks';

  @override //'CREATE_TASKS_TABLE'
  String get createTableSql => '''CREATE TABLE tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          done INTEGER NOT NULL,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP)''';

  @override
  Task get blankModel => Task(title: '', done: false);
}
