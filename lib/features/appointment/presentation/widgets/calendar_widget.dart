import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      _focusedDay = day;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(Duration(days: 365)),
        focusedDay: _focusedDay,
        onDaySelected: _onDaySelected,
        selectedDayPredicate: (day) => isSameDay(day, _focusedDay),
        locale: "en_US",
        rowHeight: 50,
        availableGestures: AvailableGestures.all,
        daysOfWeekHeight: 43,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
      ),
    );
  }
}
