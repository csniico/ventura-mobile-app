import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/appointment/data/models/appointment_model.dart';
import 'package:ventura/features/appointment/domain/entities/recurrence_schedule_entity.dart';

abstract interface class AppointmentRemoteDataSource {
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
  });

  Future<Either<Failure, AppointmentModel>> updateGoogleEventId({
    required String appointmentId,
    required String googleEventId,
    required String userId,
    required String businessId,
  });

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
  });

  Future<Either<Failure, List<AppointmentModel>>> getUserAppointments({
    required String userId,
  });

  Future<Either<Failure, List<AppointmentModel>>> getBusinessAppointments({
    required String businessId,
  });

  Future<Either<Failure, void>> deleteAppointment({
    required String appointmentId,
    required String businessId,
    required String userId,
  });
}
