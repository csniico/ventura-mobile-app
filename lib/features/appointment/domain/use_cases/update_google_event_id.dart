import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';
import 'package:ventura/features/appointment/domain/repositories/appointment_repository.dart';

class UpdateGoogleEventId
    implements UseCase<Appointment, UpdateGoogleEventIdParams> {
  final AppointmentRepository appointmentRepository;

  UpdateGoogleEventId({required this.appointmentRepository});

  @override
  Future<Either<Failure, Appointment>> call(
    UpdateGoogleEventIdParams params,
  ) async {
    return await appointmentRepository.updateGoogleEventId(
      appointmentId: params.appointmentId,
      googleEventId: params.googleEventId,
      userId: params.userId,
      businessId: params.businessId,
    );
  }
}

class UpdateGoogleEventIdParams {
  final String appointmentId;
  final String googleEventId;
  final String userId;
  final String businessId;

  UpdateGoogleEventIdParams({
    required this.appointmentId,
    required this.googleEventId,
    required this.userId,
    required this.businessId,
  });
}
