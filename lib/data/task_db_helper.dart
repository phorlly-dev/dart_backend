import '../models/task.dart';
import 'generic_db_helper.dart';

class TaskDbHelper extends GenericDbHelper<Task> {
  @override
  String get table => 'tasks';

  @override
  String get createTable => 'CREATE_TASKS_TABLE';

  @override
  Task get model => Task(title: '', done: false);
}
