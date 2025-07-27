import 'package:dart_backend/models/user.dart';
import 'generic_db_helper.dart';

class UserDbHelper extends GenericDbHelper<User> {
  @override
  String get tableName => 'users';

  @override //'CREATE_USERS_TABLE';
  String get createTableSql => 'CREATE_USERS_TABLE';
  //  '''
  //     CREATE TABLE users(
  //     id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     name TEXT NOT NULL,
  //     email TEXT NOT NULL UNIQUE,
  //     password TEXT NOT NULL,
  //     remember INTEGER NOT NULL,
  //     role INTEGER NOT NULL)
  // ''';

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
}
