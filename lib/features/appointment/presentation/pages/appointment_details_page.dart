import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Group
              _buildGroupCard(
                context,
                icon: HugeIcons.strokeRoundedInformationCircle,
                title: 'Basic Information',
                description: _buildBasicInfoDescription(),
                fields: [
                  _FieldData(
                    label: 'Title',
                    value: appointment.title,
                  ),
                  _FieldData(
                    label: 'Description',
                    value: appointment.description,
                    emptyHint: 'No description provided',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Schedule Group
              _buildGroupCard(
                context,
                icon: HugeIcons.strokeRoundedClock01,
                title: 'Schedule',
                description: _buildScheduleDescription(),
                fields: [
                  _FieldData(
                    label: 'Start',
                    value: _formatDateTime(appointment.startTime),
                  ),
                  _FieldData(
                    label: 'End',
                    value: _formatDateTime(appointment.endTime),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Notes Group
              _buildGroupCard(
                context,
                icon: HugeIcons.strokeRoundedNote,
                title: 'Notes',
                description: appointment.notes != null && appointment.notes!.isNotEmpty
                    ? 'Additional notes and reminders for this appointment.'
                    : 'No notes have been added to this appointment.',
                fields: [
                  _FieldData(
                    label: 'Notes',
                    value: appointment.notes,
                    emptyHint: 'No notes added',
                    hideLabel: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recurring Group
              _buildGroupCard(
                context,
                icon: HugeIcons.strokeRoundedRepeat,
                title: 'Recurrence',
                description: _buildRecurringDescription(),
                fields: [
                  _FieldData(
                    label: 'Recurring',
                    value: appointment.isRecurring ? 'Yes' : 'No',
                  ),
                  if (appointment.isRecurring) ...[
                    _FieldData(
                      label: 'Frequency',
                      value: _formatFrequency(appointment.recurringFrequency),
                      emptyHint: 'Frequency not set',
                    ),
                    _FieldData(
                      label: 'Until',
                      value: appointment.recurringUntil != null
                          ? _formatDate(appointment.recurringUntil!)
                          : null,
                      emptyHint: 'End date not set',
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // Sync Status Group
              _buildGroupCard(
                context,
                icon: HugeIcons.strokeRoundedCloudSavingDone01,
                title: 'Sync Status',
                description: _buildSyncDescription(),
                fields: [
                  _FieldData(
                    label: 'Google Calendar',
                    value: appointment.googleEventId != null &&
                            appointment.googleEventId != 'none'
                        ? 'Synced'
                        : null,
                    emptyHint: 'Not synced',
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _buildBasicInfoDescription() {
    final hasDescription = appointment.description != null &&
        appointment.description!.isNotEmpty;
    if (hasDescription) {
      return 'This appointment is titled "${appointment.title}" with a description provided.';
    }
    return 'This appointment is titled "${appointment.title}". No description has been added.';
  }

  String _buildScheduleDescription() {
    final duration = appointment.endTime.difference(appointment.startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    String durationText;
    if (hours > 0 && minutes > 0) {
      durationText = '$hours hour${hours > 1 ? 's' : ''} and $minutes minute${minutes > 1 ? 's' : ''}';
    } else if (hours > 0) {
      durationText = '$hours hour${hours > 1 ? 's' : ''}';
    } else {
      durationText = '$minutes minute${minutes > 1 ? 's' : ''}';
    }

    return 'This appointment is scheduled for $durationText, starting on ${_formatDate(appointment.startTime)} at ${_formatTime(appointment.startTime)}.';
  }

  String _buildRecurringDescription() {
    if (!appointment.isRecurring) {
      return 'This is a one-time appointment that does not repeat.';
    }

    final frequency = _formatFrequency(appointment.recurringFrequency)?.toLowerCase() ?? 'periodically';

    if (appointment.recurringUntil != null) {
      return 'This appointment repeats $frequency until ${_formatDate(appointment.recurringUntil!)}.';
    }

    return 'This appointment repeats $frequency with no end date specified.';
  }

  String _buildSyncDescription() {
    final isSynced = appointment.googleEventId != null &&
        appointment.googleEventId != 'none';
    if (isSynced) {
      return 'This appointment is synced with Google Calendar and will appear in both apps.';
    }
    return 'This appointment is not linked to Google Calendar.';
  }

  Widget _buildGroupCard(
    BuildContext context, {
    required dynamic icon,
    required String title,
    required String description,
    required List<_FieldData> fields,
  }) {
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
          // Header
          Row(
            children: [
              HugeIcon(icon: icon, size: 22, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Group Description
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Divider
          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 12),

          // Fields
          ...fields.map((field) => _buildField(context, field)),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context, _FieldData field) {
    final theme = Theme.of(context);
    final hasValue = field.value != null && field.value!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!field.hideLabel)
            Text(
              field.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (!field.hideLabel) const SizedBox(height: 4),
          Text(
            hasValue ? field.value! : (field.emptyHint ?? 'Not set'),
            style: hasValue
                ? theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('EEE, MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    return '${dateFormat.format(dateTime)} at ${timeFormat.format(dateTime)}';
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('MMMM d, yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
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
      case 'quarterly':
        return 'Quarterly';
      case 'yearly':
        return 'Yearly';
      default:
        return frequency;
    }
  }
}

class _FieldData {
  final String label;
  final String? value;
  final String? emptyHint;
  final bool hideLabel;

  const _FieldData({
    required this.label,
    this.value,
    this.emptyHint,
    this.hideLabel = false,
  });
}

