import 'package:dart_backend/data/user_db_helper.dart';
import 'package:dart_backend/models/login_request.dart';
import 'package:dart_backend/models/user.dart';
import 'package:dart_backend/utils/index.dart';

abstract class AuthRepository {
  Future<User> register(User req);
  Future<User?> login(LoginRequest req, {bool remember = false});
  Future<bool> logout(User req);
}

class AuthRepositoryImpl implements AuthRepository {
  final helper = UserDbHelper();

  @override
  Future<User> register(User req) => helper.make(req);

  @override
  Future<User?> login(LoginRequest req, {bool remember = false}) async {
    final res = await helper.getByEmail(req.email);
    if (res == null || !checkPwd(req.password, res.password)) return null;

    if (remember) {
      // produce a new User with remember=true and persist it
      final updated = res.copyWith(remember: true);
      await helper.release(updated);

      return updated;
    }

    return res;
  }

  @override
  Future<bool> logout(User req) async {
    if (req.remember) {
      final cleared = req.copyWith(remember: false);
      await helper.release(cleared);
    }

    return true;
  }
}
