import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  Database _instance;
  static const VERSION_DB = 11;

  static final DB _db = DB._internal();

  DB._internal();

  factory DB() {
    return _db;
  }

  Future<Database> getInstance() async {
    if (_instance == null) _instance = await _openDatabase();

    return _instance;
  }

  Future<Database> _openDatabase() async {
    final pathDB = await getDatabasesPath();
    final sqlite = openDatabase(
      join(pathDB, 'crud_users.db'),
      version: VERSION_DB,
      onCreate: (db, version) {
        print('onCreate $version');

        return db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER,
            document TEXT,
            email TEXT,
            active INTEGER
          );          
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        print('oldVersion $oldVersion');
        print('newVersion $newVersion');        
      },
    );

    return sqlite;
  }
}