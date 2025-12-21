import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/common/app_logger.dart';
import 'package:ventura/core/common/server_routes.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/data/models/server_exception.dart';
import 'package:ventura/features/appointment/data/data_sources/remote/abstract_interfaces/appointment_remote_data_source.dart';
import 'package:ventura/features/appointment/data/models/appointment_model.dart';
import 'package:ventura/features/appointment/domain/entities/recurrence_schedule_entity.dart';

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final Dio dio;
  final routes = ServerRoutes.instance;
  final logger = AppLogger('AppointmentRemoteDataSourceImpl');

  AppointmentRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, AppointmentModel>> createAppointment({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required bool isRecurring,
    required String userId,
    required String businessId,
    String? description,
    String? notes,
    RecurrenceSchedule? recurrenceSchedule,
  }) async {
    try {
      final response = await dio.post(
        '${routes.serverUrl}${routes.createAppointment}',
        data: {
          'title': title,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'isRecurring': isRecurring,
          'userId': userId,
          'businessId': businessId,
          'description': description,
          'notes': notes,
          'recurrenceSchedule': recurrenceSchedule,
        },
      );
      logger.info(response.toString());
      return right(AppointmentModel.fromJson(response.data));
    } on DioException catch (e) {
      logger.error(e.response.toString());
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<Either<Failure, String>> deleteAppointment({
    required String appointmentId,
    required String userId,
    required String businessId,
  }) async {
    try {
      final response = await dio.delete(
        '${routes.serverUrl}${routes.deleteAppointment(appointmentId)}',
        data: {'businessId': businessId, 'userId': userId},
      );
      logger.info(response.data.toString());
      return right(response.data.message);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>> getBusinessAppointments({
    required String businessId,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getBusinessAppointments}',
        data: {'businessId': businessId},
      );
      logger.info(response.data.toString());
      return right(
        response.data.map((e) => AppointmentModel.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      logger.error(e.response.toString());
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>> getUserAppointments({
    required String userId,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getBusinessAppointments}',
        data: {'userId': userId},
      );
      logger.info(response.data.toString());
      return right(
        response.data.map((e) => AppointmentModel.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      logger.error(e.response.toString());
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> updateAppointment({
    required String appointmentId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required bool isRecurring,
    required String userId,
    required String businessId,
    String? description,
    String? notes,
    RecurrenceSchedule? recurrenceSchedule,
  }) async {
    try {
      final response = await dio.put(
        '${routes.serverUrl}${routes.updateAppointment(appointmentId)}',
        data: {
          'title': title,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'isRecurring': isRecurring,
          'userId': userId,
          'businessId': businessId,
          'description': description,
          'notes': notes,
          'recurrenceSchedule': recurrenceSchedule,
        },
      );
      logger.info(response.data.toString());
      return right(AppointmentModel.fromJson(response.data));
    } on DioException catch (e) {
      logger.error(e.response.toString());
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> updateGoogleEventId({
    required String appointmentId,
    required String googleEventId,
    required String userId,
    required String businessId,
  }) async {
    try {
      final response = await dio.put(
        '${routes.serverUrl}${routes.updateGoogleCalendarEvent(appointmentId)}',
        data: {
          'googleEventId': googleEventId,
          'userId': userId,
          'businessId': businessId,
        },
      );
      logger.info(response.data.toString());
      return right(AppointmentModel.fromJson(response.data));
    } on DioException catch (e) {
      logger.error(e.response.toString());
      throw ServerException.fromDioError(e);
    }
  }
}
