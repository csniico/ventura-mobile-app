import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ventura/features/appointment/presentation/widgets/action_bottom_sheet.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime firstDay; // Add this
  final void Function(DateTime, DateTime) onDateSelected;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.firstDay,
  });
  static Future<DateTime?> show(
    BuildContext context,
    DateTime initialDate, {
    DateTime? firstDay,
  }) async {
    DateTime tempDate = initialDate;

    return await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ActionBottomSheet(
              onApply: () => Navigator.pop(context, tempDate),
              child: CalendarWidget(
                firstDay: firstDay ?? DateTime.now(),
                selectedDate: tempDate,
                onDateSelected: (newDate, focusedDate) {
                  setState(() => tempDate = newDate);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: firstDay,
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: selectedDate,
      selectedDayPredicate: (day) => isSameDay(day, selectedDate),
      onDaySelected: onDateSelected,
      locale: "en_US",
      rowHeight: 45,
      daysOfWeekHeight: 45,
      availableGestures: AvailableGestures.all,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.blue, // Match your app theme
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
