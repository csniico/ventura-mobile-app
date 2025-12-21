import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';

class AppointmentModel extends Appointment {
  AppointmentModel({
    required super.id,
    required super.userId,
    required super.businessId,
    required super.googleEventId,
    required super.title,
    required super.startTime,
    required super.endTime,
    required super.description,
    required super.notes,
    required super.isRecurring,
    required super.recurrenceSchedule,
  });

  factory AppointmentModel.empty() {
    return AppointmentModel(
      id: '',
      userId: '',
      businessId: '',
      googleEventId: '',
      title: '',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      description: '',
      notes: '',
      isRecurring: false,
      recurrenceSchedule: null,
    );
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      businessId: json['businessId'] ?? '',
      googleEventId: json['googleEventId'] ?? '',
      title: json['title'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      description: json['description'] ?? '',
      notes: json['notes'] ?? '',
      isRecurring: json['isRecurring'] ?? '',
      recurrenceSchedule: json['recurrenceSchedule'],
    );
  }

  factory AppointmentModel.fromEntity(Appointment appointment) {
    return AppointmentModel(
      id: appointment.id,
      userId: appointment.userId,
      businessId: appointment.businessId,
      googleEventId: appointment.googleEventId,
      title: appointment.title,
      startTime: appointment.startTime,
      endTime: appointment.endTime,
      description: appointment.description,
      notes: appointment.notes,
      isRecurring: appointment.isRecurring,
      recurrenceSchedule: appointment.recurrenceSchedule,
    );
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      businessId: map['businessId'] ?? '',
      googleEventId: map['googleEventId'] ?? '',
      title: map['title'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      description: map['description'] ?? '',
      notes: map['notes'] ?? '',
      isRecurring: map['isRecurring'] ?? false,
      recurrenceSchedule: map['recurrenceSchedule'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'businessId': businessId,
      'googleEventId': googleEventId,
      'title': title,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'description': description,
      'notes': notes,
      'isRecurring': isRecurring,
      'recurrenceSchedule': recurrenceSchedule,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'businessId': businessId,
      'googleEventId': googleEventId,
      'title': title,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'description': description,
      'notes': notes,
      'isRecurring': isRecurring,
      'recurrenceSchedule': recurrenceSchedule,
    };
  }

  Appointment toEntity() {
    return Appointment(
      id: id,
      userId: userId,
      businessId: businessId,
      googleEventId: googleEventId,
      title: title,
      startTime: startTime,
      endTime: endTime,
      description: description,
      notes: notes,
      isRecurring: isRecurring,
      recurrenceSchedule: recurrenceSchedule,
    );
  }
}
