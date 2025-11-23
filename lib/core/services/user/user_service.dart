import 'package:ventura/core/models/business/business.dart';
import 'package:ventura/core/models/user/user.dart';
import 'package:ventura/core/services/database/database_service.dart';

class UserService {
  // Singleton setup
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final DatabaseService _databaseService = DatabaseService.instance;

  User? _currentUser;

  /// Signs the user out, deactivating them in the database and clearing the cache.
  Future<void> signOut() async {
    if (_currentUser?.id != null) {
      await _databaseService.signOut(_currentUser!.id);
    }
    _currentUser = null;
  }

  /// Loads the user from the local database and caches it in the service.
  Future<void> loadUser() async {
    _currentUser = await _databaseService.getUser();
  }

  /// Saves a user to the local database, sets them as the active user, and updates the cache.
  Future<void> saveUser(User user) async {
    await _databaseService.saveUser(user);
    _currentUser = user;
    // After saving, also sign them in to set as active user
    await _databaseService.signIn(user.id);
  }

  /// Deletes all user data from the database and clears the cache.
  Future<void> deleteUser() async {
    await _databaseService.deleteUser();
    _currentUser = null;
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
  Business? get employerBusiness => _currentUser?.employerBusiness; // Renamed
  bool? get isSystem => _currentUser?.isSystem;
}
