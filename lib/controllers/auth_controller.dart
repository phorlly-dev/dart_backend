import 'package:dart_backend/data/auth_helper.dart';
import 'package:dart_backend/data/user_db_helper.dart';
import 'package:dart_backend/models/login_request.dart';
import 'package:dart_backend/models/user.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepositoryImpl();
  final UserDbHelper _helper = UserDbHelper();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<User> currentUser = Rxn<User>();

  /// REGISTER
  Future<void> register(User req) async {
    try {
      isLoading.value = true;
      final hashed = hashPwd(req.password);
      final safed = req.copyWith(password: hashed);
      final created = await _repo.register(safed);

      currentUser.value = created;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Register failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGIN
  Future<void> login(LoginRequest req, bool rememberMe) async {
    try {
      isLoading.value = true;
      final res = await _repo.login(req, remember: rememberMe);
      if (res == null) {
        errorMessage.value = 'Invalid email or password';
        return;
      }

      currentUser.value = res;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Login failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGOUT
  void logout() async {
    await _repo.logout(currentUser.value!);
    currentUser.value = null;
  }

  ///AUTO LOGIN
  Future<void> _tryAutoLogin() async {
    final res = await _helper.getRememberedUser();
    if (res != null) {
      currentUser.value = res;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _tryAutoLogin();
  }
}
