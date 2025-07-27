import 'package:dart_backend/data/user_db_helper.dart';
import 'package:dart_backend/models/user.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final _db = UserDbHelper();

  /// The list your UI will observe
  final RxList<User> users = <User>[].obs;

  /// Loading & error state
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
      users.assignAll(all);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not load users: $e';
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
      errorMessage.value = 'Could not load user #$id: $e';
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
      users.add(res);
      errorMessage.value = '';
      // for DESC order (newest at top):
      users.sort((a, b) => b.id!.compareTo(a.id!));

      // OR, for ASC order (newest at bottom):
      // users.sort((a, b) => a.id!.compareTo(b.id!));
    } catch (e) {
      errorMessage.value = 'Could not create user: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// UPDATE
  Future<void> change(User req) async {
    try {
      isLoading.value = true;
      await _db.release(req);
      final idx = users.indexWhere((res) => res.id == req.id);
      if (idx != -1) users[idx] = req;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not update user: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// DELETE
  Future<void> remove(int id) async {
    try {
      isLoading.value = true;
      await _db.destoy(id);
      users.removeWhere((res) => res.id == id);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not delete user: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
