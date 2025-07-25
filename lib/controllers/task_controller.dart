import 'package:dart_backend/data/task_db_helper.dart';
import 'package:dart_backend/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final TaskDbHelper _db = TaskDbHelper();

  /// The list your UI will observe
  final RxList<Task> tasks = <Task>[].obs;

  /// Loading & error state
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    index(); // load tasks as soon as controller is created
  }

  /// FETCH ALL
  Future<void> index() async {
    try {
      isLoading.value = true;
      final all = await _db.list();
      tasks.assignAll(all);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not load tasks: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// FETCH ONE
  Future<Task?> show(int id) async {
    try {
      isLoading.value = true;
      final t = await _db.retrieve(id);
      return t;
    } catch (e) {
      errorMessage.value = 'Could not load task #$id: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// CREATE
  Future<void> store(Task task) async {
    try {
      isLoading.value = true;
      final newTask = await _db.make(task);
      tasks.add(newTask);
      errorMessage.value = '';
      // for DESC order (newest at top):
      tasks.sort((a, b) => b.id!.compareTo(a.id!));

      // OR, for ASC order (newest at bottom):
      // tasks.sort((a, b) => a.id!.compareTo(b.id!));
    } catch (e) {
      errorMessage.value = 'Could not create task: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// UPDATE
  Future<void> change(Task task) async {
    try {
      isLoading.value = true;
      await _db.release(task);
      final idx = tasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) tasks[idx] = task;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not update task: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// DELETE
  Future<void> remove(int id) async {
    try {
      isLoading.value = true;
      await _db.destoy(id);
      tasks.removeWhere((t) => t.id == id);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not delete task: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
