import 'package:flutter/foundation.dart';
import 'package:ventura/core/models/business/business.dart';
import 'package:ventura/core/models/user/user.dart';
import 'package:ventura/core/services/database/database_service.dart';

class BusinessService {
  // Singleton setup
  static final BusinessService _instance = BusinessService._internal();
  factory BusinessService() => _instance;
  BusinessService._internal();

  final DatabaseService _databaseService = DatabaseService.instance;

  Business? _currentBusiness;
  List<Business> _userBusinesses = [];

  /// Loads the active business from the database and caches it.
  Future<void> loadActiveBusiness() async {
    _currentBusiness = await _databaseService.getActiveBusiness();
    debugPrint(
        "[BusinessService] Loaded active business: ${_currentBusiness?.name}");
  }

  /// Synchronizes business data after user login.
  Future<List<Business>> syncUserBusinesses(User user) async {
    final allBusinesses = <Business>{};
    if (user.ownedBusinesses != null) {
      allBusinesses.addAll(user.ownedBusinesses!);
    }
    if (user.employerBusiness != null) {
      allBusinesses.add(user.employerBusiness!);
    }

    if (allBusinesses.isEmpty) {
      debugPrint("[BusinessService] No businesses found for the user.");
      _userBusinesses = [];
      _currentBusiness = null;
      return [];
    }

    debugPrint(
        "[BusinessService] Found ${allBusinesses.length} unique businesses. Syncing with local database...");
    for (final business in allBusinesses) {
      await _databaseService.saveBusiness(business);
    }

    _userBusinesses = allBusinesses.toList();

    // Set the first business as active by default.
    final businessToActivate = _userBusinesses.first;
    await setActiveBusiness(businessToActivate);

    return _userBusinesses;
  }

  /// Sets a new business as the current active one in the database and service.
  Future<void> setActiveBusiness(Business business) async {
    await _databaseService.setActiveBusiness(business.id);
    _currentBusiness = business;
    debugPrint(
        "[BusinessService] Manually set active business to: ${business.name}");
  }

  // --- Getters for the current state ---

  /// Returns the full cached [Business] object for the active business.
  Business? get currentBusiness => _currentBusiness;

  /// Returns a list of all businesses associated with the user.
  List<Business> get userBusinesses => _userBusinesses;

  // --- Getters for individual properties of the current business ---

  String? get id => _currentBusiness?.id;
  String? get name => _currentBusiness?.name;
  String? get description => _currentBusiness?.description;
  String? get email => _currentBusiness?.email;
  String? get phone => _currentBusiness?.phone;
  String? get website => _currentBusiness?.website;
  String? get logo => _currentBusiness?.logo;
  String? get address => _currentBusiness?.address;
  String? get city => _currentBusiness?.city;
  String? get state => _currentBusiness?.state;
  String? get country => _currentBusiness?.country;
  String? get zipCode => _currentBusiness?.zipCode;
  String? get ownerId => _currentBusiness?.ownerId;
  bool? get isActive => _currentBusiness?.isActive;
}
