enum RecurrenceFrequency {
  daily,
  weekly,
  monthly,
  yearly,
}


class RecurringSchedule {
  final DateTime? until;
  final RecurrenceFrequency? frequency;

  RecurringSchedule({
    required this.until,
    required this.frequency,
  });
}