import 'package:dart_backend/models/user_response.dart';
import 'db_request.dart';

class UserRequest extends DbRequest<UserResponse> {
  @override
  String get tableName => 'users';

  @override //'CREATE_USERS_TABLE'
  String get createTableSql => '';

  @override
  UserResponse get blankModel =>
      UserResponse(name: '', email: '', password: '');

  /// Find a user by email (for login)
  Future<UserResponse?> getByEmail(String email) async {
    final db = await database;
    final rows = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: [email],
    );
    if (rows.isEmpty) return null;

    return blankModel.fromMap(rows.first);
  }

  Future<UserResponse?> getRememberedUser() async {
    final db = await database;
    final rows = await db.query(
      tableName,
      where: 'remember = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return null;

    return blankModel.fromMap(rows.first);
  }
}
