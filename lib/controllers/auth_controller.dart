import 'package:dart_backend/services/auth_request.dart';
import 'package:dart_backend/services/user_request.dart';
import 'package:dart_backend/models/login_response.dart';
import 'package:dart_backend/models/user_response.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class AuthController extends GetxController {
  final IAuth _repo = AuthRequest();
  final UserRequest _helper = UserRequest();
  final Rxn<UserResponse> currentUser = Rxn<UserResponse>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// REGISTER
  Future<void> register(UserResponse req) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final hashed = hashPwd(req.password);
      final safed = req.copyWith(password: hashed);

      final created = await _repo.register(safed);
      currentUser.value = created;
    } on DatabaseException catch (e) {
      // SQLite returns code 19 for constraint violations
      if (e.isUniqueConstraintError()) {
        errorMessage.value = 'That email is already registered';
      } else {
        errorMessage.value = 'Registration failed: $e';
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGIN
  Future<void> login(LoginResponse req, bool rememberMe) async {
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
    } on Exception catch (e) {
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
  Future<UserResponse?> tryAutoLogin() async {
    final res = await _helper.getRememberedUser();
    if (res != null) {
      currentUser.value = res;

      return currentUser.value;
    }

    return null;
  }
}
