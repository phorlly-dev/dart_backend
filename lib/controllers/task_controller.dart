import 'package:dart_backend/data/task_db_helper.dart';
import 'package:dart_backend/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final _db = TaskDbHelper();
  final RxList<Task> states = <Task>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    index();
  }

  /// FETCH ALL
  Future<void> index() async {
    try {
      isLoading.value = true;
      final all = await _db.list();
      states.assignAll(all);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not load records: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// FETCH ONE
  Future<Task?> show(int id) async {
    try {
      isLoading.value = true;
      final res = await _db.retrieve(id);
      return res;
    } catch (e) {
      errorMessage.value = 'Could not load record #$id: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// CREATE
  Future<void> store(Task req) async {
    try {
      isLoading.value = true;
      final res = await _db.make(req);
      states.add(res);
      errorMessage.value = '';
      // for DESC order (newest at top):
      states.sort((a, b) => b.id!.compareTo(a.id!));

      // OR, for ASC order (newest at bottom):
      // states.sort((a, b) => a.id!.compareTo(b.id!));
    } catch (e) {
      errorMessage.value = 'Could not create record: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// UPDATE
  Future<void> change(Task req) async {
    try {
      isLoading.value = true;
      await _db.release(req);
      final idx = states.indexWhere((res) => res.id == req.id);
      if (idx != -1) states[idx] = req;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not update record: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// DELETE
  Future<void> remove(int id) async {
    try {
      isLoading.value = true;
      await _db.destoy(id);
      states.removeWhere((res) => res.id == id);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not delete record: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
