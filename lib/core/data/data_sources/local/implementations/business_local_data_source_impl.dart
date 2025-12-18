import 'package:ventura/core/data/data_sources/local/abstract_interfaces/business_local_data_source.dart';
import 'package:ventura/core/data/models/business_model.dart';
import 'package:ventura/core/services/business_service.dart';

class BusinessLocalDataSourceImpl implements BusinessLocalDataSource {
  final BusinessService businessService;

  BusinessLocalDataSourceImpl({required this.businessService});

  @override
  Future<void> clearBusiness() async {
    return await businessService.clearBusiness();
  }

  @override
  Future<BusinessModel?> getBusiness() async {
    return await businessService.getBusiness();
  }

  @override
  Future<BusinessModel> saveBusiness(BusinessModel business) async {
    return await businessService.saveBusiness(business);
  }
}
