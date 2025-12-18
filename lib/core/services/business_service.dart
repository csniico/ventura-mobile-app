import 'package:ventura/core/common/app_logger.dart';
import 'package:ventura/core/data/data_sources/database/database_service.dart';
import 'package:ventura/core/data/models/business_model.dart';

class BusinessService {
  final AppLogger _logger = AppLogger('BusinessService');

  //   Singleton Setup
  static final BusinessService _instance = BusinessService._internal();

  factory BusinessService() => _instance;

  BusinessService._internal();

  final DatabaseService _databaseService = DatabaseService.instance;

  BusinessModel? _currentBusiness;

  /// Retrieves the current business from the database
  Future<BusinessModel?> getBusiness() async {
    try {
      final business = await _databaseService.getBusiness();
      _logger.info('BusinessService: Retrieved business: $business');
      _currentBusiness = business;
      return business;
    } catch (e) {
      _logger.error('BusinessService: Error retrieving business: $e');
      return null;
    }
  }

  /// Saves a business to the local database, sets it as the active business, and updates the cache.
  Future<BusinessModel> saveBusiness(BusinessModel business) async {
    try {
      final savedBusiness = await _databaseService.saveBusiness(business);
      _currentBusiness = savedBusiness;
      return savedBusiness;
    } catch (e) {
      _logger.error('BusinessService: Error saving business: $e');
      rethrow;
    }
  }

  Future<void> clearBusiness() async {
    try {
      await _databaseService.clearBusiness();
      _currentBusiness = null;
    } catch (e) {
      _logger.error('BusinessService: Error clearing business: $e');
    }
  }

  /// Clears the cached business (useful for logout)
  void clearCache() {
    _currentBusiness = null;
  }

  /// Returns the full cached [BusinessModel] object.
  BusinessModel? get business => _currentBusiness;

  /// Returns true if a business is currently loaded.
  bool get hasBusiness => _currentBusiness != null;
}
