import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/home/domain/entities/dashboard_entity.dart';
import 'package:ventura/features/home/domain/repositories/dashboard_repository.dart';

class GetDashboardData
    implements UseCase<DashboardData, GetDashboardDataParams> {
  final DashboardRepository dashboardRepository;

  GetDashboardData({required this.dashboardRepository});

  @override
  Future<Either<Failure, DashboardData>> call(
    GetDashboardDataParams params,
  ) async {
    return await dashboardRepository.getDashboardData(
      businessId: params.businessId,
    );
  }
}

class GetDashboardDataParams {
  final String businessId;

  GetDashboardDataParams({required this.businessId});
}
