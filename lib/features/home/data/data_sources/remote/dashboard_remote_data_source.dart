import 'package:ventura/features/home/data/models/dashboard_model.dart';

abstract interface class DashboardRemoteDataSource {
  Future<DashboardDataModel?> getDashboardData({required String businessId});
}
