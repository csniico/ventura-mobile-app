import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ventura/core/common/app_logger.dart';
import 'package:ventura/core/data/models/business_model.dart';
import 'package:ventura/core/data/models/user_model.dart';

class DatabaseService {
  final AppLogger _logger = AppLogger('DatabaseService');

  static Database? _db;
  static final DatabaseService instance = DatabaseService._internal();

  factory DatabaseService() => instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  Future<Database> init() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");

    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE IF NOT EXISTS user (
            id TEXT PRIMARY KEY,
            data TEXT NOT NULL
          );
        """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS business (
            id TEXT PRIMARY KEY,
            data TEXT NOT NULL
          );
        """);
      },
    );
  }

  Future<UserModel> saveUser(UserModel user) async {
    final db = await database;

    await db.delete('user');

    await db.insert('user', {
      'id': user.id,
      'data': jsonEncode(user.toJson()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    return user;
  }

  Future<UserModel?> getUser() async {
    final db = await database;

    final userRows = await db.query('user', limit: 1);
    if (userRows.isEmpty) return null;

    final Map<String, dynamic> userJson = jsonDecode(
      userRows.first['data'] as String,
    );

    final businessRows = await db.query('business', limit: 1);
    if (businessRows.isNotEmpty) {
      userJson['business'] = jsonDecode(businessRows.first['data'] as String);
    }

    debugPrint('DatabaseService: Retrieved user data: $userJson');
    return UserModel.fromJson(userJson);
  }

  Future<void> signOut() async {
    final db = await database;
    await db.delete('user');
  }

  Future<BusinessModel> saveBusiness(BusinessModel business) async {
    final db = await database;

    await db.delete('business');

    await db.insert('business', {
      'id': business.id,
      'data': jsonEncode(business.toJson()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    return business;
  }

  Future<BusinessModel> getBusiness() async {
    final db = await database;

    final rows = await db.query('business', limit: 1);
    final data = jsonDecode(rows.first['data'] as String);

    _logger.info('DatabaseService: Retrieved business data: $data');
    return BusinessModel.fromJson(data);
  }

  Future<void> clearBusiness() async {
    final db = await database;
    await db.delete('business');
  }
}
