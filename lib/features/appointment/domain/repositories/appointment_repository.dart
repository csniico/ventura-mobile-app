import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';
import 'package:ventura/features/appointment/domain/entities/recurrence_schedule_entity.dart';

abstract interface class AppointmentRepository {
  Future<Either<Failure, Appointment>> createAppointment({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required bool isRecurring,
    required String userId,
    required String businessId,
    String? description,
    String? notes,
    RecurringSchedule? recurringSchedule,
  });

  Future<Either<Failure, Appointment>> updateGoogleEventId({
    required String appointmentId,
    required String googleEventId,
    required String userId,
    required String businessId,
  });

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
    RecurringSchedule? recurringSchedule,
  });

  Future<Either<Failure, List<Appointment>>> getUserAppointments({
    required String userId,
  });

  Future<Either<Failure, List<Appointment>>> getBusinessAppointments({
    required String businessId,
  });

  Future<Either<Failure, String>> deleteAppointment({
    required String appointmentId,
    required String businessId,
    required String userId,
  });
}
