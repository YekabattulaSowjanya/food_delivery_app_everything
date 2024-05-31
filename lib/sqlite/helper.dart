import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/sqlite/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'billing_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.internal();

  factory DatabaseHelper() => instance;

  static Database? _database;
  static Database? _billingDatabase;

  DatabaseHelper.internal();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_user_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db!.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<User?> getUserByEmail(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  /// Billing table methods

  Future<Database> get billingDatabase async {
    if (_billingDatabase != null) return _billingDatabase!;
    _billingDatabase = await _initBillingDB('user_info.db');
    return _billingDatabase!;
  }

  Future<Database> _initBillingDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/$filePath';
    return await openDatabase(path, version: 1, onCreate: _createBillingDB);
  }

  Future<void> _createBillingDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE user_info (
        id $idType,
        fullName $textType,
        email $textType,
        address $textType,
        city $textType,
        state $textType,
        country $textType,
        pinCode $textType
        phoneNumber $textType
      )
    ''');
  }

  Future<int?> insertUserInfo(UserInfo userInfo) async {
    final db = await billingDatabase;
    return await db.insert('user_info', userInfo.toMap());
  }

  Future<UserInfo?> getUserInfoByEmail(String email) async {
    final db = await billingDatabase;

    debugPrint(('db:$db '));

    final List<Map<String, dynamic>> maps = await db.query(
      'user_info',
      where: 'email = ?',
      whereArgs: [email],
    );
    debugPrint(('maps:$maps '));

    if (maps.isNotEmpty) {
      debugPrint('element : ${maps.first}');
      return UserInfo.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
