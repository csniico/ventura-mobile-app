import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/appointment/domain/repositories/appointment_repository.dart';

class DeleteAppointment implements UseCase<String, DeleteAppointmentParams> {
  final AppointmentRepository appointmentRepository;

  DeleteAppointment({required this.appointmentRepository});

  @override
  Future<Either<Failure, String>> call(DeleteAppointmentParams params) async {
    return await appointmentRepository.deleteAppointment(
      appointmentId: params.appointmentId,
      businessId: params.businessId,
      userId: params.userId,
    );
  }
}

class DeleteAppointmentParams {
  final String appointmentId;
  final String businessId;
  final String userId;

  DeleteAppointmentParams({
    required this.appointmentId,
    required this.businessId,
    required this.userId,
  });
}
