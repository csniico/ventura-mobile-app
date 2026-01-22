import 'package:flutter/material.dart';

/// Enum representing the status of an appointment based on its timing
enum AppointmentStatus { upcoming, today, inProgress, completed }

/// A badge widget that displays the status of an appointment
/// with appropriate colors and labels.
class AppointmentStatusBadge extends StatelessWidget {
  const AppointmentStatusBadge({
    super.key,
    required this.startTime,
    required this.endTime,
  });

  final DateTime startTime;
  final DateTime endTime;

  /// Computes the appointment status based on current time
  static AppointmentStatus computeStatus(DateTime startTime, DateTime endTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = DateTime(startTime.year, startTime.month, startTime.day);

    if (now.isAfter(endTime)) {
      return AppointmentStatus.completed;
    } else if (now.isAfter(startTime) && now.isBefore(endTime)) {
      return AppointmentStatus.inProgress;
    } else if (startDate == today) {
      return AppointmentStatus.today;
    } else {
      return AppointmentStatus.upcoming;
    }
  }

  /// Returns the display label for a status
  static String statusLabel(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return 'Upcoming';
      case AppointmentStatus.today:
        return 'Today';
      case AppointmentStatus.inProgress:
        return 'In Progress';
      case AppointmentStatus.completed:
        return 'Completed';
    }
  }

  /// Returns the color for a status
  static Color statusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return const Color(0xFF3B82F6); // Blue
      case AppointmentStatus.today:
        return const Color(0xFFF59E0B); // Amber
      case AppointmentStatus.inProgress:
        return const Color(0xFF10B981); // Green
      case AppointmentStatus.completed:
        return const Color(0xFF6B7280); // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = computeStatus(startTime, endTime);
    final color = statusColor(status);
    final label = statusLabel(status);

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
