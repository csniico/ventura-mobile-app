import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';
import 'package:ventura/features/appointment/domain/repositories/appointment_repository.dart';

class GetUserAppointment
    implements UseCase<List<Appointment>, GetUserAppointmentsParams> {
  final AppointmentRepository appointmentRepository;

  GetUserAppointment({required this.appointmentRepository});

  @override
  Future<Either<Failure, List<Appointment>>> call(
    GetUserAppointmentsParams params,
  ) async {
    return await appointmentRepository.getUserAppointments(
      userId: params.userId,
    );
  }
}

class GetUserAppointmentsParams {
  final String userId;

  GetUserAppointmentsParams({required this.userId});
}
