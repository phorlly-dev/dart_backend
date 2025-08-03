import 'package:dart_backend/data/event_db_helper.dart';
import 'package:dart_backend/models/event.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final _db = EventDbHelper();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Event> items = <Event>[].obs;
  final Rxn<Event> currentEvent = Rxn<Event>();

  /// FETCH ALL
  Future<void> index() async {
    try {
      isLoading.value = true;
      final all = await _db.list();
      items.assignAll(all);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not load records: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// FETCH ONE
  Future<void> show(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await _db.retrieve(id);
      if (res == null) {
        errorMessage.value = 'Not found';
      }

      currentEvent.value = res;
    } catch (e) {
      errorMessage.value = 'Could not load record #$id: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// CREATE
  Future<void> store(Event req) async {
    try {
      isLoading.value = true;
      final res = await _db.make(req);

      items.add(res);
      items.refresh();

      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not create record: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// UPDATE
  Future<void> change(Event req) async {
    try {
      isLoading.value = true;
      await _db.release(req);

      final idx = items.indexWhere((res) => res.id == req.id);
      if (idx != -1) {
        items[idx] = req;
        items.refresh();
      }

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

      items.removeWhere((res) => res.id == id);

      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not delete record: $e';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    index();
  }
}
