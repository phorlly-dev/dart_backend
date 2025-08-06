import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Singleton that opens your database exactly once,
/// runs ALL registered create‐table scripts on first open,
/// and exposes the same Database to every helper.
class DbProvider {
  DbProvider._();
  static final DbProvider instance = DbProvider._();

  static final _dbName = 'app.db';
  static final _dbVersion = 1;

  final List<String> _tableScripts = [];
  Database? _db;

  /// Called by each helper to register its CREATE TABLE DDL.
  void registerTable(String createTableSql) {
    if (!_tableScripts.contains(createTableSql)) {
      _tableScripts.add(createTableSql);
    }
  }

  /// Lazily opens (and on first open, creates) the SQLite database.
  Future<Database> get database async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    final sql = await rootBundle.loadString('assets/db/migrations.sql');

    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        for (final script in sql.split(';')) {
          final query = script.trim();
          if (query.isNotEmpty) await db.execute('$query;');
        }
        // for (final script in _tableScripts) {
        //   await db.execute(script);
        // }
      },
      // onOpen: (db) async {
      //   if (_tableScripts.isNotEmpty) {
      //     for (final script in _tableScripts) {
      //       await db.execute(script);
      //     }
      //   }
      // },
    );

    return _db!;
  }
}
