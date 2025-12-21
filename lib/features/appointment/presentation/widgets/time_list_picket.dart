import 'package:flutter/material.dart';

class TimeListPicker extends StatelessWidget {
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onChanged;
  final double itemHeight;
  final double height;

  const TimeListPicker({
    super.key,
    required this.selectedTime,
    required this.onChanged,
    this.itemHeight = 48,
    this.height = 500,
  });

  // Generate times from 00:00 → 23:30
  List<TimeOfDay> _generateTimes() {
    final times = <TimeOfDay>[];

    for (int hour = 0; hour < 24; hour++) {
      times.add(TimeOfDay(hour: hour, minute: 0));
      times.add(TimeOfDay(hour: hour, minute: 30));
    }

    return times;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  bool _isSame(TimeOfDay a, TimeOfDay b) {
    return a.hour == b.hour && a.minute == b.minute;
  }

  @override
  Widget build(BuildContext context) {
    final times = _generateTimes();

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: times.length,
                itemBuilder: (context, index) {
                  final time = times[index];
                  final isSelected = _isSame(time, selectedTime);

                  return InkWell(
                    onTap: () => onChanged(time),
                    child: Container(
                      height: itemHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: isSelected
                          ? Colors.grey.shade200
                          : Colors.transparent,
                      child: Row(
                        children: [
                          Text(
                            _formatTime(time),
                            style: TextStyle(
                              fontSize: 16,
                              // color: isSelected  Colors.blu,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            const Icon(Icons.check,
                                size: 20, color: Colors.blue),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
