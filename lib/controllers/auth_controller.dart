import 'package:dart_backend/data/auth_helper.dart';
import 'package:dart_backend/data/user_db_helper.dart';
import 'package:dart_backend/models/login_request.dart';
import 'package:dart_backend/models/user.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepositoryImpl();
  final UserDbHelper _helper = UserDbHelper();
  final Rxn<User> currentUser = Rxn<User>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// REGISTER
  Future<void> register(User req) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final hashed = hashPwd(req.password);
      final safed = req.copyWith(password: hashed);

      final created = await _repo.register(safed);
      currentUser.value = created;
    } catch (e) {
      errorMessage.value = 'Register failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGIN
  Future<void> login(LoginRequest req, bool rememberMe) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1️⃣ Look up by email
      final user = await _repo.findByEmail(req.email);
      if (user == null) {
        errorMessage.value = 'No account found for that email.';
        return;
      }

      // 2️⃣ Check password
      if (!checkPwd(req.password, user.password)) {
        errorMessage.value = 'Invalid email or password.';
        return;
      }

      // 3️⃣ Success!
      currentUser.value = user;

      // 4️⃣ Optionally remember me
      if (rememberMe) {
        final updated = user.copyWith(remember: true);
        await _helper.release(updated);
        currentUser.value = updated;
      }
    } catch (e) {
      errorMessage.value = 'Login failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _repo.logout(currentUser.value!);
    errorMessage.value = 'The session has been cleared.';
    currentUser.value = null;
  }

  ///AUTO LOGIN
  Future<User?> tryAutoLogin() async {
    final res = await _helper.getRememberedUser();
    if (res != null) {
      currentUser.value = res;

      return currentUser.value;
    }

    return null;
  }
}
