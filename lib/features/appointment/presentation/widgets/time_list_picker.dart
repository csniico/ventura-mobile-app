import 'package:flutter/material.dart';
import 'package:ventura/features/appointment/presentation/widgets/action_bottom_sheet.dart';

class TimeListPicker extends StatefulWidget {
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onChanged;
  final double itemHeight;
  final double height;
  final TimeOfDay? minTime;

  const TimeListPicker({
    super.key,
    required this.selectedTime,
    required this.onChanged,
    this.itemHeight = 48,
    this.height = 450,
    this.minTime,
  });

  // --- STATIC HELPER METHOD ---
  static Future<TimeOfDay?> show(
    BuildContext context,
    TimeOfDay initialTime, {
    TimeOfDay? minTime,
  }) async {
    TimeOfDay tempTime = initialTime;

    return await showModalBottomSheet<TimeOfDay>(
      context: context,
      isScrollControlled: true, // Allows expansion
      builder: (context) {
        // We use StatefulBuilder to update the UI inside the sheet
        // without rebuilding the whole page
        return StatefulBuilder(
          builder: (context, setState) {
            return ActionBottomSheet(
              onApply: () => Navigator.pop(context, tempTime),
              child: TimeListPicker(
                selectedTime: tempTime,
                minTime: minTime,
                onChanged: (newTime) {
                  setState(() => tempTime = newTime);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  State<TimeListPicker> createState() => _TimeListPickerState();
}

class _TimeListPickerState extends State<TimeListPicker> {
  // Generate times from 00:00 -> 23:30
  List<TimeOfDay> _generateTimes(TimeOfDay? minTime) {
    final times = <TimeOfDay>[];
    for (int hour = 0; hour < 24; hour++) {
      for (int min in [0, 30]) {
        final time = TimeOfDay(hour: hour, minute: min);
        // Only add if no minTime is provided, or if time is after minTime
        if (minTime == null ||
            (hour > minTime.hour ||
                (hour == minTime.hour && min > minTime.minute))) {
          times.add(time);
        }
      }
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
    final times = _generateTimes(widget.minTime);

    return SizedBox(
      height: widget.height,
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
                  final isSelected = _isSame(time, widget.selectedTime);

                  return InkWell(
                    onTap: () => widget.onChanged(time),
                    child: Container(
                      height: widget.itemHeight,
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
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.blue,
                            ),
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
