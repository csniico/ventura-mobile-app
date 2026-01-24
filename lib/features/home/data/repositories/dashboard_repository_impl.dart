import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/home/data/data_sources/remote/dashboard_remote_data_source.dart';
import 'package:ventura/features/home/domain/entities/dashboard_entity.dart';
import 'package:ventura/features/home/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardData>> getDashboardData({
    required String businessId,
  }) async {
    try {
      final dashboard = await remoteDataSource.getDashboardData(
        businessId: businessId,
      );

      if (dashboard == null) {
        return left(Failure('Failed to fetch dashboard data'));
      }

      return right(dashboard);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
