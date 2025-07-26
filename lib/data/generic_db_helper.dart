// lib/data/generic_db_helper.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// 1️⃣ Define a contract for any model you want to persist:
///    – needs a zero-arg constructor or factory fromMap,
///    – must be able to turn itself into a Map<String,dynamic>.
abstract class DbModel {
  /// Build a model from a DB row.
  DbModel fromMap(Map<String, dynamic> map);

  /// Turn a model into a row.
  Map<String, dynamic> toMap();
}

/// 2️⃣ Create a generic, reusable base helper:
abstract class GenericDbHelper<T extends DbModel> {
  static Database? _database;

  /// Subclasses just tell us:
  ///  • which table
  ///  • how to create it
  ///  • and how to map back & forth
  String get table;
  String get createTable;
  T get model; // used to call fromMap

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final dbName = dotenv.env['DB_NAME']!;
    final query = dotenv.env[createTable]!;
    final path = join(dbPath, dbName);
    _database = await openDatabase(
      path,
      version: int.parse(dotenv.env['DB_VERSION'] ?? '1'),
      onCreate: (db, version) => db.execute(query),
    );
    return _database!;
  }

  Future<T> make(T model) async {
    final db = await database;
    final id = await db.insert(table, model.toMap());
    final fullMap = {...model.toMap(), 'id': id};
    return model.fromMap(fullMap) as T;
  }

  Future<List<T>> list() async {
    final db = await database;
    final rows = await db.query(table, orderBy: 'id DESC');
    return rows.map((r) => model.fromMap(r) as T).toList();
  }

  Future<T?> retrieve(int id) async {
    final db = await database;
    final rows = await db.query(table, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return model.fromMap(rows.first) as T;
  }

  Future<int> release(T model) async {
    final db = await database;
    return db.update(
      table,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.toMap()['id']],
    );
  }

  Future<int> destoy(int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
