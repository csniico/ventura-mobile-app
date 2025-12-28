import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';
import 'package:ventura/features/appointment/domain/repositories/appointment_repository.dart';

class UpdateAppointment
    implements UseCase<Appointment, UpdateAppointmentParams> {
  final AppointmentRepository appointmentRepository;

  UpdateAppointment({required this.appointmentRepository});

  @override
  Future<Either<Failure, Appointment>> call(
    UpdateAppointmentParams params,
  ) async {
    return await appointmentRepository.updateAppointment(
      appointmentId: params.appointmentId,
      title: params.title,
      startTime: params.startTime,
      endTime: params.endTime,
      isRecurring: params.isRecurring,
      userId: params.userId,
      businessId: params.businessId,
      description: params.description,
      notes: params.notes,
      recurringUntil: params.recurringUntil,
      recurringFrequency: params.recurringFrequency,
    );
  }
}

class UpdateAppointmentParams {
  final String appointmentId;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool isRecurring;
  final String userId;
  final String businessId;
  String? description;
  String? notes;
  DateTime? recurringUntil;
  String? recurringFrequency;

  UpdateAppointmentParams({
    required this.appointmentId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.isRecurring,
    required this.userId,
    required this.businessId,
    this.description,
    this.notes,
    this.recurringUntil,
    this.recurringFrequency,
  });
}
