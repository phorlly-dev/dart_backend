import 'package:dart_backend/data/user_db_helper.dart';
import 'package:dart_backend/models/user.dart';

abstract class AuthRepository {
  Future<User> register(User req);
  Future<User?> findByEmail(String email);
  Future<bool> logout(User req);
}

class AuthRepositoryImpl implements AuthRepository {
  final helper = UserDbHelper();

  @override
  Future<User> register(User req) => helper.make(req);

  @override
  Future<User?> findByEmail(String email) => helper.getByEmail(email);

  @override
  Future<bool> logout(User req) async {
    if (req.remember) {
      final cleared = req.copyWith(remember: false);
      await helper.release(cleared);
    }

    return true;
  }
}
