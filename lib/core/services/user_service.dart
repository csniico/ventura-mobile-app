import 'package:flutter/cupertino.dart';
import 'package:ventura/core/data/models/user_model.dart';
import 'package:ventura/core/data/datasources/database/database_service.dart';

class UserService {
  // Singleton setup
  static final UserService _instance = UserService._internal();

  factory UserService() => _instance;

  UserService._internal();

  final DatabaseService _databaseService = DatabaseService.instance;

  UserModel? _currentUser;

  /// Retrieves the current user from the database
  Future<UserModel?> getUser() async {
    final user = await _databaseService.getUser();
    debugPrint('UserService: Retrieved user: $user');
    _currentUser = user;
    return user;
  }

  /// Saves a user to the local database, sets them as the active user, and updates the cache.
  Future<UserModel> saveUser(UserModel user) async {
    final savedUser = await _databaseService.saveUser(user);
    _currentUser = savedUser;
    return savedUser;
  }

  Future<void> signOut() async {
    await _databaseService.signOut();
    clearUser();
  }

  /// Clears the cached user (useful for logout)
  void clearUser() {
    _currentUser = null;
  }

  /// Returns the full cached [UserModel] object.
  UserModel? get user => _currentUser;

  /// Returns true if a user is currently loaded.
  bool get hasUser => _currentUser != null;

  // --- Getters for individual user properties ---

  String? get id => _currentUser?.id;

  String? get firstName => _currentUser?.firstName;

  String? get lastName => _currentUser?.lastName;

  String? get email => _currentUser?.email;

  String? get avatarUrl => _currentUser?.avatarUrl;

  String? get googleId => _currentUser?.googleId;

  String? get businessId => _currentUser?.businessId;

  bool? get isSystem => _currentUser?.isSystem;
}