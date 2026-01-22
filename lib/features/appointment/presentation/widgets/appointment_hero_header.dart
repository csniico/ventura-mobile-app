import 'package:flutter/material.dart';
import 'package:ventura/features/appointment/presentation/widgets/appointment_status_badge.dart';

/// A hero header widget that displays the appointment title, status badge,
/// and relative time information prominently at the top of the details page.
class AppointmentHeroHeader extends StatelessWidget {
  const AppointmentHeroHeader({
    super.key,
    required this.title,
    required this.startTime,
    required this.endTime,
  });

  final String title;
  final DateTime startTime;
  final DateTime endTime;

  /// Computes a human-readable relative time string
  String _computeRelativeTime() {
    final now = DateTime.now();
    final status = AppointmentStatusBadge.computeStatus(startTime, endTime);

    switch (status) {
      case AppointmentStatus.completed:
        final difference = now.difference(endTime);
        if (difference.inDays == 0) {
          return 'Ended earlier today';
        } else if (difference.inDays == 1) {
          return 'Ended yesterday';
        } else if (difference.inDays < 7) {
          return 'Ended ${difference.inDays} days ago';
        } else if (difference.inDays < 30) {
          final weeks = (difference.inDays / 7).floor();
          return 'Ended $weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
        } else {
          final months = (difference.inDays / 30).floor();
          return 'Ended $months ${months == 1 ? 'month' : 'months'} ago';
        }

      case AppointmentStatus.inProgress:
        final remaining = endTime.difference(now);
        if (remaining.inMinutes < 60) {
          return '${remaining.inMinutes} min remaining';
        } else {
          final hours = remaining.inHours;
          final minutes = remaining.inMinutes % 60;
          if (minutes > 0) {
            return '${hours}h ${minutes}m remaining';
          }
          return '$hours ${hours == 1 ? 'hour' : 'hours'} remaining';
        }

      case AppointmentStatus.today:
        final timeUntil = startTime.difference(now);
        if (timeUntil.inMinutes < 60) {
          return 'Starts in ${timeUntil.inMinutes} min';
        } else {
          final hours = timeUntil.inHours;
          return 'Starts in $hours ${hours == 1 ? 'hour' : 'hours'}';
        }

      case AppointmentStatus.upcoming:
        final difference = startTime.difference(now);
        if (difference.inDays == 1) {
          return 'Tomorrow';
        } else if (difference.inDays < 7) {
          return 'In ${difference.inDays} days';
        } else if (difference.inDays < 30) {
          final weeks = (difference.inDays / 7).floor();
          return 'In $weeks ${weeks == 1 ? 'week' : 'weeks'}';
        } else {
          final months = (difference.inDays / 30).floor();
          return 'In $months ${months == 1 ? 'month' : 'months'}';
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final relativeTime = _computeRelativeTime();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Appointment title
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // Relative time
          Text(
            relativeTime,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          // Status badge
          AppointmentStatusBadge(startTime: startTime, endTime: endTime),
        ],
      ),
    );
  }
}
