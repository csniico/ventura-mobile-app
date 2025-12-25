import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ventura/core/common/app_logger.dart';
import 'package:ventura/core/common/server_routes.dart';
import 'package:ventura/features/appointment/data/data_sources/remote/abstract_interfaces/appointment_remote_data_source.dart';
import 'package:ventura/features/appointment/data/models/appointment_model.dart';
import 'package:ventura/features/appointment/domain/entities/recurrence_schedule_entity.dart';

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final Dio dio;
  final routes = ServerRoutes.instance;
  final logger = AppLogger('AppointmentRemoteDataSourceImpl');

  AppointmentRemoteDataSourceImpl({required this.dio});

  @override
  Future<AppointmentModel?> createAppointment({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required bool isRecurring,
    required String userId,
    required String businessId,
    String? description,
    String? notes,
    RecurringSchedule? recurringSchedule,
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
          if (isRecurring) 'recurringSchedule': recurringSchedule,
        },
      );
      logger.info(response.toString());
      return AppointmentModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<String?> deleteAppointment({
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
      if (response.data is Map<String, dynamic>) {
        return response.data['message'] as String?;
      }
      return response.data as String?;
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<List<AppointmentModel>?> getBusinessAppointments({
    required String businessId,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getBusinessAppointments}',
        data: {'businessId': businessId},
      );
      logger.info(response.data.toString());
      return List<AppointmentModel>.from(
          response.data.map((e) => AppointmentModel.fromJson(e))
      );
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<List<AppointmentModel>?> getUserAppointments({
    required String userId,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getBusinessAppointments}',
        data: {'userId': userId},
      );
      final appointments = List<AppointmentModel>.from(
          response.data.map((e) => AppointmentModel.fromJson(e))
      ).toList();
      return appointments;
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<AppointmentModel?> updateAppointment({
    required String appointmentId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required bool isRecurring,
    required String userId,
    required String businessId,
    String? description,
    String? notes,
    RecurringSchedule? recurringSchedule,
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
          if (isRecurring) 'recurringSchedule': recurringSchedule,
        },
      );
      logger.info(response.data.toString());
      return AppointmentModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<AppointmentModel?> updateGoogleEventId({
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
      return AppointmentModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }
}
