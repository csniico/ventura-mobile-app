import 'package:ventura/features/appointment/domain/entities/recurrence_schedule_entity.dart';

class RecurrenceScheduleModel extends RecurrenceSchedule {
  RecurrenceScheduleModel({required super.until, required super.frequency});

  factory RecurrenceScheduleModel.fromJson(Map<String, dynamic> json) {
    return RecurrenceScheduleModel(
      until: DateTime.parse(json['until']),
      frequency: RecurrenceFrequency.values.firstWhere(
        (freq) => freq.toString() == json['frequency'],
      ),
    );
  }

  factory RecurrenceScheduleModel.fromEntity(RecurrenceSchedule entity) {
    return RecurrenceScheduleModel(
      until: entity.until,
      frequency: entity.frequency,
    );
  }

  factory RecurrenceScheduleModel.fromMap(Map<String, dynamic> map) {
    return RecurrenceScheduleModel(
      until: DateTime.parse(map['until']),
      frequency: RecurrenceFrequency.values.firstWhere(
        (freq) => freq.toString() == map['frequency'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'until': until.toIso8601String(),
      'frequency': frequency.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'until': until.toIso8601String(),
      'frequency': frequency.toString(),
    };
  }

  RecurrenceSchedule toEntity() {
    return RecurrenceSchedule(until: until, frequency: frequency);
  }
}
