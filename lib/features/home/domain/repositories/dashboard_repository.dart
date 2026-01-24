import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/home/domain/entities/dashboard_entity.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, DashboardData>> getDashboardData({
    required String businessId,
  });
}
