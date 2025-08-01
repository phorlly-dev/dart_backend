import 'package:dart_backend/controllers/control_provider.dart';
import 'package:dart_backend/data/user_db_helper.dart';
import 'package:dart_backend/models/user.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:get/get.dart';

class UserController extends ControlProvider<User> {
  final _db = UserDbHelper();

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
      items.assignAll(all);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not load records: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// FETCH ONE
  Future<User?> show(int id) async {
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
  Future<void> store(User req) async {
    try {
      isLoading.value = true;
      final hashed = hashPwd(req.password);
      final safed = req.copyWith(password: hashed);
      final res = await _db.make(safed);
      items.add(res);
      errorMessage.value = '';
      // for DESC order (newest at top):
      items.sort((a, b) => b.id!.compareTo(a.id!));

      // OR, for ASC order (newest at bottom):
      // items.sort((a, b) => a.id!.compareTo(b.id!));
    } catch (e) {
      errorMessage.value = 'Could not create record: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// UPDATE
  Future<void> change(User req) async {
    try {
      isLoading.value = true;
      await _db.release(req);
      final idx = items.indexWhere((res) => res.id == req.id);
      if (idx != -1) items[idx] = req;
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
}
