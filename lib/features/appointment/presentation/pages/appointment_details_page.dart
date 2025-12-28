import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';

class AppointmentDetailsPage extends StatelessWidget {
  const AppointmentDetailsPage({super.key, required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        actions: [
          TextButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/edit-appointment',
                arguments: appointment,
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              context,
              icon: Icons.title,
              title: 'Title',
              value: appointment.title,
              footnote: 'The name or subject of this appointment.',
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              context,
              icon: Icons.description,
              title: 'Description',
              value: appointment.description,
              footnote: 'A brief summary of what this appointment is about.',
              emptyHint:
                  'No description provided. Add one to help remember the purpose of this appointment.',
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              context,
              icon: Icons.calendar_today,
              title: 'Start Date & Time',
              value: _formatDateTime(appointment.startTime),
              footnote: 'When this appointment begins.',
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              context,
              icon: Icons.event_available,
              title: 'End Date & Time',
              value: _formatDateTime(appointment.endTime),
              footnote: 'When this appointment ends.',
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              context,
              icon: Icons.note,
              title: 'Notes',
              value: appointment.notes,
              footnote:
                  'Additional information or reminders for this appointment.',
              emptyHint:
                  'No notes added. Use this space for any extra details.',
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              context,
              icon: Icons.repeat,
              title: 'Recurring',
              value: appointment.isRecurring ? 'Yes' : 'No',
              footnote:
                  'Indicates whether this appointment repeats on a schedule.',
            ),
            if (appointment.isRecurring) ...[
              const SizedBox(height: 16),
              _buildDetailCard(
                context,
                icon: Icons.schedule,
                title: 'Frequency',
                value: _formatFrequency(appointment.recurringFrequency),
                footnote: 'How often this appointment repeats.',
                emptyHint:
                    'Frequency not set. Update to define the recurrence pattern.',
              ),
              const SizedBox(height: 16),
              _buildDetailCard(
                context,
                icon: Icons.event_busy,
                title: 'Repeats Until',
                value: appointment.recurringUntil != null
                    ? _formatDateTime(appointment.recurringUntil!)
                    : null,
                footnote:
                    'The last date this recurring appointment will occur.',
                emptyHint:
                    'End date not set. Update to specify when recurrence stops.',
              ),
            ],
            const SizedBox(height: 16),
            _buildDetailCard(
              context,
              icon: Icons.event,
              title: 'Google Calendar',
              value:
                  appointment.googleEventId != null &&
                      appointment.googleEventId != 'none'
                  ? 'Synced'
                  : null,
              footnote:
                  'Shows if this appointment is linked to Google Calendar.',
              emptyHint: 'Not synced with Google Calendar.',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String? value,
    required String footnote,
    String? emptyHint,
  }) {
    final bool hasValue = value != null && value.isNotEmpty;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasValue ? value : (emptyHint ?? 'Not set'),
            style: hasValue
                ? theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            footnote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    return '${dateFormat.format(dateTime)} at ${timeFormat.format(dateTime)}';
  }

  String? _formatFrequency(String? frequency) {
    if (frequency == null) return null;
    switch (frequency) {
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      case 'bi-weekly':
        return 'Every 2 weeks';
      case 'monthly':
        return 'Monthly';
      case 'bi-monthly':
        return 'Every 2 months';
      case 'yearly':
        return 'Yearly';
      default:
        return frequency;
    }
  }
}
