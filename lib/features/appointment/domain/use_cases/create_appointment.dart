import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';
import 'package:ventura/features/appointment/domain/repositories/appointment_repository.dart';

class CreateAppointment
    implements UseCase<Appointment, CreateAppointmentParams> {
  final AppointmentRepository appointmentRepository;

  CreateAppointment({required this.appointmentRepository});

  @override
  Future<Either<Failure, Appointment>> call(
    CreateAppointmentParams params,
  ) async {
    return await appointmentRepository.createAppointment(
      title: params.title,
      startTime: params.startTime,
      endTime: params.endTime,
      isRecurring: params.isRecurring,
      userId: params.userId,
      businessId: params.businessId,
      notes: params.notes,
      description: params.description,
      recurringFrequency: params.recurringFrequency,
      recurringUntil: params.recurringUntil,
    );
  }
}

class CreateAppointmentParams {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool isRecurring;
  final String userId;
  final String businessId;
  final String? description;
  final String? notes;
  final DateTime? recurringUntil;
  final String? recurringFrequency;

  CreateAppointmentParams({
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
