import 'package:dart_backend/models/user.dart';
import 'generic_db_helper.dart';

class UserDbHelper extends GenericDbHelper<User> {
  @override
  String get tableName => 'users';

  @override
  String get createTableSql => 'CREATE_USERS_TABLE';

  @override
  User get blankModel =>
      User(name: '', email: '', password: '', role: false, remember: false);

  /// Find a user by email (for login)
  Future<User?> getByEmail(String email) async {
    final db = await database;
    final rows = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: [email],
    );
    if (rows.isEmpty) return null;

    return blankModel.fromMap(rows.first);
  }

  Future<User?> getRememberedUser() async {
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
