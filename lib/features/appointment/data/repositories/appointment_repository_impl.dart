import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/appointment/data/data_sources/remote/abstract_interfaces/appointment_remote_data_source.dart';
import 'package:ventura/features/appointment/data/models/appointment_model.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';
import 'package:ventura/features/appointment/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource appointmentRemoteDataSource;

  AppointmentRepositoryImpl({required this.appointmentRemoteDataSource});

  @override
  Future<Either<Failure, Appointment>> createAppointment({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required bool isRecurring,
    required String userId,
    required String businessId,
    String? description,
    String? notes,
    DateTime? recurringUntil,
    String? recurringFrequency,
  }) async {
    AppointmentModel? appointmentModel = await appointmentRemoteDataSource
        .createAppointment(
          title: title,
          startTime: startTime,
          endTime: endTime,
          isRecurring: isRecurring,
          userId: userId,
          businessId: businessId,
          description: description,
          notes: notes,
          recurringUntil: recurringUntil,
          recurringFrequency: recurringFrequency,
        );
    if (appointmentModel == null) {
      return left(Failure('Failed to create appointment'));
    }
    return right(appointmentModel.toEntity());
  }

  @override
  Future<Either<Failure, Appointment>> updateAppointment({
    required String appointmentId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required bool isRecurring,
    required String userId,
    required String businessId,
    String? description,
    String? notes,
    DateTime? recurringUntil,
    String? recurringFrequency,
  }) async {
    AppointmentModel? appointmentModel = await appointmentRemoteDataSource
        .updateAppointment(
          appointmentId: appointmentId,
          title: title,
          startTime: startTime,
          endTime: endTime,
          isRecurring: isRecurring,
          userId: userId,
          businessId: businessId,
          description: description,
          notes: notes,
          recurringUntil: recurringUntil,
          recurringFrequency: recurringFrequency,
        );
    if (appointmentModel == null) {
      return left(Failure('Failed to update appointment'));
    }
    return right(appointmentModel.toEntity());
  }

  @override
  Future<Either<Failure, String>> deleteAppointment({
    required String appointmentId,
    required String businessId,
    required String userId,
  }) async {
    String? message = await appointmentRemoteDataSource.deleteAppointment(
      appointmentId: appointmentId,
      businessId: businessId,
      userId: userId,
    );
    if (message == null) {
      return left(Failure('Failed to delete appointment'));
    }
    return right(message);
  }

  @override
  Future<Either<Failure, List<Appointment>>> getBusinessAppointments({
    required String businessId,
  }) async {
    List<AppointmentModel>? appointmentModel = await appointmentRemoteDataSource
        .getBusinessAppointments(businessId: businessId);
    if (appointmentModel == null) {
      return left(Failure('Failed to get appointments'));
    }
    return right(appointmentModel.map((e) => e.toEntity()).toList());
  }

  @override
  Future<Either<Failure, List<Appointment>>> getUserAppointments({
    required String userId,
  }) async {
    List<AppointmentModel>? appointmentModel = await appointmentRemoteDataSource
        .getUserAppointments(userId: userId);
    if (appointmentModel == null) {
      return left(Failure('Failed to get appointments'));
    }
    return right(appointmentModel.map((e) => e.toEntity()).toList());
  }

  @override
  Future<Either<Failure, Appointment>> updateGoogleEventId({
    required String appointmentId,
    required String googleEventId,
    required String userId,
    required String businessId,
  }) async {
    AppointmentModel? appointmentModel = await appointmentRemoteDataSource
        .updateGoogleEventId(
          appointmentId: appointmentId,
          googleEventId: googleEventId,
          userId: userId,
          businessId: businessId,
        );
    if (appointmentModel == null) {
      return left(Failure('Failed to update appointment'));
    }
    return right(appointmentModel.toEntity());
  }
}
