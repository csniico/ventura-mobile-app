part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentEvent {}

final class AppointmentCreateEvent extends AppointmentEvent {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool isRecurring;
  final String userId;
  final String businessId;
  final String? description;
  final String? notes;
  final RecurrenceSchedule? recurrenceSchedule;

  AppointmentCreateEvent({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.isRecurring,
    required this.userId,
    required this.businessId,
    this.description,
    this.notes,
    this.recurrenceSchedule,
  });
}

final class AppointmentGetEvent extends AppointmentEvent {
  final String? userId;
  final String? businessId;

  AppointmentGetEvent({this.userId, this.businessId});
}

final class AppointmentUpdateEvent extends AppointmentEvent {
  final String appointmentId;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool isRecurring;
  final String userId;
  final String businessId;
  final String? description;
  final String? notes;
  final RecurrenceSchedule? recurrenceSchedule;

  AppointmentUpdateEvent({
    required this.appointmentId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.isRecurring,
    required this.userId,
    required this.businessId,
    this.description,
    this.notes,
    this.recurrenceSchedule,
  });
}

final class AppointmentUpdateGoogleIdEvent extends AppointmentEvent {
  final String appointmentId;
  final String googleEventId;
  final String userId;
  final String businessId;

  AppointmentUpdateGoogleIdEvent({
    required this.appointmentId,
    required this.googleEventId,
    required this.userId,
    required this.businessId,
  });
}

final class AppointmentDeleteEvent extends AppointmentEvent {
  final String appointmentId;
  final String businessId;
  final String userId;

  AppointmentDeleteEvent({
    required this.appointmentId,
    required this.businessId,
    required this.userId,
  });
}
