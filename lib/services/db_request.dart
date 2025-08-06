// lib/data/generic_db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'db_provider.dart';

/// Contract your models must implement.
abstract class IModel {
  /// Every model needs to be able to turn a DB row into itself.
  IModel fromMap(Map<String, dynamic> map);

  /// …and itself into a row map.
  Map<String, dynamic> toMap();
}

/// A reusable base class—just extend this, pass your table‐name, DDL, and a "blank" model.
abstract class DbRequest<T extends IModel> {
  DbRequest() {
    // automatically register this table for creation
    DbProvider.instance.registerTable(createTableSql);
  }

  /// The actual table name in SQLite.
  String get tableName;

  /// The CREATE TABLE statement for this model.
  String get createTableSql;

  /// A “blank” instance so we can call `fromMap`.
  T get blankModel;

  /// Syntactic sugar: the shared Database instance.
  Future<Database> get database async => await DbProvider.instance.database;

  /// CREATE → returns the model with its new `id` populated.
  Future<T> make(T model) async {
    final db = await database;
    final id = await db.insert(tableName, model.toMap());

    return (model as dynamic).copyWith(id: id) as T;
  }

  /// READ ALL → sorted descending by ID by default
  Future<List<T>> list({String orderBy = 'id DESC'}) async {
    final db = await database;
    final rows = await db.query(tableName, orderBy: orderBy);

    return rows.map((res) => blankModel.fromMap(res) as T).toList();
  }

  /// READ ONE → by primary key
  Future<T?> retrieve(int id) async {
    final db = await database;
    final rows = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    return blankModel.fromMap(rows.first) as T;
  }

  /// UPDATE → returns number of rows affected
  Future<int> release(T model) async {
    final db = await database;
    final data = model.toMap();

    return db.update(tableName, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  /// DELETE → by primary key
  Future<int> destoy(int id) async {
    final db = await database;

    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
