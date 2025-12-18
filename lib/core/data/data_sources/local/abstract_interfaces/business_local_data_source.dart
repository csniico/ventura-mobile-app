import 'package:ventura/core/data/models/business_model.dart';

abstract interface class BusinessLocalDataSource {
  Future<BusinessModel?> getBusiness();

  Future<BusinessModel> saveBusiness(BusinessModel business);

  Future<void> clearBusiness();
}
