enum RecurrenceFrequency {
  daily,
  weekly,
  monthly,
  yearly,
}


class RecurrenceSchedule {
  final DateTime until;
  final RecurrenceFrequency frequency;
  
  RecurrenceSchedule({
    required this.until,
    required this.frequency,
  });
}