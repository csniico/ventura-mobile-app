import 'package:ventura/features/appointment/data/models/appointment_model.dart';

abstract interface class AppointmentRemoteDataSource {
  Future<AppointmentModel?> createAppointment({
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
  });

  Future<AppointmentModel?> updateGoogleEventId({
    required String appointmentId,
    required String googleEventId,
    required String userId,
    required String businessId,
  });

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
    DateTime? recurringUntil,
    String? recurringFrequency,
  });

  Future<List<AppointmentModel>?> getUserAppointments({required String userId});

  Future<List<AppointmentModel>?> getBusinessAppointments({
    required String businessId,
  });

  Future<String?> deleteAppointment({
    required String appointmentId,
    required String businessId,
    required String userId,
  });
}
