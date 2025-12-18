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
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE IF NOT EXISTS user (
            id TEXT PRIMARY KEY,
            shortId TEXT,
            firstName TEXT,
            lastName TEXT,
            email TEXT,
            avatarUrl TEXT,
            googleId TEXT,
            businessId TEXT,
            isSystem INTEGER,
            isActive INTEGER DEFAULT 0,
            isEmailVerified INTEGER DEFAULT 0
          );
        """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS business (
            id TEXT PRIMARY KEY,
            shortId TEXT,
            ownerId TEXT,
            email TEXT,
            phone TEXT,
            name TEXT,
            description TEXT,
            tagLine TEXT,
            categories TEXT,
            logo TEXT,
            city TEXT,
            state TEXT,
            country TEXT,
            address TEXT
          );
        """);
      },
    );
    return database;
  }

  // USER CRUD OPERATIONS
  Future<UserModel> saveUser(UserModel user) async {
    final db = await database;
    await db.delete('user');
    await db.insert(
      "user",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user;
  }

  Future<UserModel?> getUser() async {
    final db = await database;
    final user = await db.query('user');
    debugPrint('DatabaseService: Retrieved user data: $user');
    if (user.length > 1) {
      //   more than one user exists, clear users and return null
      await db.delete('user');
      return null;
    }
    if (user.isEmpty) {
      return null;
    }
    return UserModel.fromJson(user.first);
  }

  Future<void> signOut() async {
    final db = await database;
    await db.delete('user');
  }

  Future<BusinessModel> saveBusiness(BusinessModel business) async {
    final db = await database;
    await db.delete('business');
    await db.insert(
      "business",
      business.toMap(forDatabase: true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return business;
  }

  Future<BusinessModel> getBusiness() async {
    final db = await database;
    final business = await db.query('business');
    _logger.info('DatabaseService: Retrieved business data: $business');
    return BusinessModel.fromJson(business.first, fromDatabase: true);
  }

  Future<void> clearBusiness() async {
    final db = await database;
    await db.delete('business');
  }
}
