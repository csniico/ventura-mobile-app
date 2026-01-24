import 'package:dio/dio.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/config/server_routes.dart';
import 'package:ventura/features/home/data/data_sources/remote/dashboard_remote_data_source.dart';
import 'package:ventura/features/home/data/models/dashboard_model.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;
  final routes = ServerRoutes.instance;
  final logger = AppLogger('DashboardRemoteDataSourceImpl');

  DashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<DashboardDataModel?> getDashboardData({
    required String businessId,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.dashboardSummary}',
        queryParameters: {'businessId': businessId},
      );
      logger.info(response.data.toString());
      return DashboardDataModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }
}
