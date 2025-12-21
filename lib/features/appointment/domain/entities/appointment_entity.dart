import 'package:ventura/features/appointment/domain/entities/recurrence_schedule_entity.dart';

class Appointment {
  final String id;
  final String userId;
  final String businessId;
  final String googleEventId;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String description;
  final String notes;
  final bool isRecurring;
  RecurrenceSchedule? recurrenceSchedule;

  Appointment({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.googleEventId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.notes,
    required this.isRecurring,
    this.recurrenceSchedule,
  });

  Appointment copyWith({
    String? id,
    String? userId,
    String? businessId,
    String? googleEventId,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    String? description,
    String? notes,
    bool? isRecurring,
    RecurrenceSchedule? recurrenceSchedule,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      googleEventId: googleEventId ?? this.googleEventId,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceSchedule: recurrenceSchedule ?? this.recurrenceSchedule,
    );
  }
}
