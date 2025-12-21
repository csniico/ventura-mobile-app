part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentState {}

final class AppointmentInitial extends AppointmentState {}

final class AppointmentLoadingState extends AppointmentState {}

final class AppointmentCreateSuccessState extends AppointmentState {
  final Appointment appointment;

  AppointmentCreateSuccessState({required this.appointment});
}

final class AppointmentGetSuccessState extends AppointmentState {
  final List<Appointment>? appointments;

  AppointmentGetSuccessState({this.appointments});
}

final class AppointmentUpdateSuccessState extends AppointmentState {
  final Appointment appointment;

  AppointmentUpdateSuccessState({required this.appointment});
}

final class AppointmentDeleteSuccessState extends AppointmentState {
  final String message;

  AppointmentDeleteSuccessState({required this.message});
}

final class AppointmentErrorState extends AppointmentState {
  final String message;

  AppointmentErrorState({required this.message});
}
