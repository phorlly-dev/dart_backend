// lib/data/database_provider.dart

import 'package:dart_backend/utils/index.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Singleton that opens your database exactly once,
/// runs ALL registered create‐table scripts on first open,
/// and exposes the same Database to every helper.
class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider instance = DatabaseProvider._();

  static final _dbName = setEnv('DB_NAME');
  static final _dbVersion = setEnv('DB_VERSION');

  final List<String> _tableScripts = [];
  Database? _db;

  /// Called by each helper to register its CREATE TABLE DDL.
  void registerTable(String createTableSql) {
    final sqlQuery = setEnv(createTableSql);
    if (!_tableScripts.contains(sqlQuery)) {
      _tableScripts.add(sqlQuery!);
    }
  }

  /// Lazily opens (and on first open, creates) the SQLite database.
  Future<Database> get database async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    _db = await openDatabase(
      path,
      version: int.parse(_dbVersion ?? '1'),
      onCreate: (db, version) async {
        for (final script in _tableScripts) {
          await db.execute(script);
        }
      },
    );

    return _db!;
  }
}
