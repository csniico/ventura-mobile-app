import 'package:ventura/features/appointment/domain/entities/recurrence_schedule_entity.dart';

class RecurringScheduleModel extends RecurringSchedule {
  RecurringScheduleModel({required super.until, required super.frequency});

  factory RecurringScheduleModel.fromJson(Map<String, dynamic> json) {
    return RecurringScheduleModel(
      until: json['until'] != null ? DateTime.parse(json['until']) : null,
      frequency: json['frequency'] == null
          ? null
          : RecurrenceFrequency.values.firstWhere(
              (freq) => freq.name == json['frequency'],
              orElse: () => RecurrenceFrequency.daily,
            ),
    );
  }

  factory RecurringScheduleModel.fromEntity(RecurringSchedule entity) {
    return RecurringScheduleModel(
      until: entity.until,
      frequency: entity.frequency,
    );
  }

  factory RecurringScheduleModel.fromMap(Map<String, dynamic> map) {
    return RecurringScheduleModel(
      until: DateTime.parse(map['until']),
      frequency: RecurrenceFrequency.values.firstWhere(
        (freq) => freq.name == map['frequency'],
        orElse: () => RecurrenceFrequency.daily,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'until': until?.toIso8601String(),
      'frequency': frequency?.name,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'until': until?.toIso8601String(),
      'frequency': frequency?.name,
    };
  }

  RecurringSchedule toEntity() {
    return RecurringSchedule(until: until, frequency: frequency);
  }
}
