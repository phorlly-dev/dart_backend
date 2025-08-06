import 'package:dart_backend/services/user_request.dart';
import 'package:dart_backend/models/user_response.dart';

abstract class IAuth {
  Future<UserResponse> register(UserResponse req);
  Future<UserResponse?> findByEmail(String email);
  Future<bool> logout(UserResponse req);
}

class AuthRequest implements IAuth {
  final helper = UserRequest();

  @override
  Future<UserResponse> register(UserResponse req) => helper.make(req);

  @override
  Future<UserResponse?> findByEmail(String email) => helper.getByEmail(email);

  @override
  Future<bool> logout(UserResponse req) async {
    if (req.remember) {
      final cleared = req.copyWith(remember: false);
      await helper.release(cleared);
    }

    return true;
  }
}
