import 'package:ventura/core/entities/user_entity.dart';
import 'package:ventura/core/models/user_model.dart';
import 'package:ventura/core/services/database/database_service.dart';

class UserService {
  // Singleton setup
  static final UserService _instance = UserService._internal();

  factory UserService() => _instance;

  UserService._internal();

  final DatabaseService _databaseService = DatabaseService.instance;

  User? _currentUser;

  Future<User?> getUser() async {
    final user = await _databaseService.getUser();
    _currentUser = user;
    return user;
  }

  /// Saves a user to the local database, sets them as the active user, and updates the cache.
  Future<User> saveUser(UserModel user) async {
    return await _databaseService.saveUser(user);
  }

  /// Returns the full cached [User] object.
  User? get user => _currentUser;

  /// Returns true if a user is currently loaded.
  bool get hasUser => _currentUser != null;

  // --- Getters for individual user properties ---

  String? get id => _currentUser?.id;

  String? get firstName => _currentUser?.firstName;

  String? get lastName => _currentUser?.lastName;

  String? get email => _currentUser?.email;

  String? get avatarUrl => _currentUser?.avatarUrl;

  String? get googleId => _currentUser?.googleId;

  bool? get isSystem => _currentUser?.isSystem;
}
