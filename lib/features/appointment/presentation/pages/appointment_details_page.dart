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
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8.0),
          child: const SizedBox(height: 8.0),
        ),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Appointment Details',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedPencilEdit02,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 26,
            ),
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
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Group - Blue (calm, professional, trust)
              _buildGroupCard(
                context,
                icon: HugeIcons.strokeRoundedInformationCircle,
                title: 'Basic Information',
                description: _buildBasicInfoDescription(),
                cardColor: const Color(0xFF3B82F6), // Blue
                fields: [
                  _FieldData(label: 'Title', value: appointment.title),
                  _FieldData(
                    label: 'Description',
                    value: appointment.description,
                    emptyHint: 'No description provided',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Schedule Group - Purple (time, planning, organization)
              _buildGroupCard(
                context,
                icon: HugeIcons.strokeRoundedClock01,
                title: 'Schedule',
                description: _buildScheduleDescription(),
                cardColor: const Color(0xFF8B5CF6), // Purple
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

              // Notes Group - Amber (attention, reminders, warmth)
              _buildGroupCard(
                context,
                icon: HugeIcons.strokeRoundedNote,
                title: 'Notes',
                description:
                    appointment.notes != null && appointment.notes!.isNotEmpty
                        ? 'Additional notes and reminders for this appointment.'
                        : 'No notes have been added to this appointment.',
                cardColor: const Color(0xFFF59E0B), // Amber
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

              // Recurring Group - Green (growth, continuity, routine)
              _buildGroupCard(
                context,
                icon: HugeIcons.strokeRoundedRepeat,
                title: 'Recurrence',
                description: _buildRecurringDescription(),
                cardColor: const Color(0xFF10B981), // Green
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

              // Sync Status Group - Teal (technology, connection, sync)
              _buildGroupCard(
                context,
                icon: HugeIcons.strokeRoundedCloudSavingDone01,
                title: 'Sync Status',
                description: _buildSyncDescription(),
                cardColor: const Color(0xFF14B8A6), // Teal
                fields: [
                  _FieldData(
                    label: 'Google Calendar',
                    value:
                        appointment.googleEventId != null &&
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
    final hasDescription =
        appointment.description != null && appointment.description!.isNotEmpty;
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
      durationText =
          '$hours hour${hours > 1 ? 's' : ''} and $minutes minute${minutes > 1 ? 's' : ''}';
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

    final frequency =
        _formatFrequency(appointment.recurringFrequency)?.toLowerCase() ??
        'periodically';

    if (appointment.recurringUntil != null) {
      return 'This appointment repeats $frequency until ${_formatDate(appointment.recurringUntil!)}.';
    }

    return 'This appointment repeats $frequency with no end date specified.';
  }

  String _buildSyncDescription() {
    final isSynced =
        appointment.googleEventId != null &&
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
    required Color cardColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Create a softer background color based on the card color
    final backgroundColor = isDark
        ? cardColor.withValues(alpha: 0.15)
        : cardColor.withValues(alpha: 0.08);

    final borderColor = isDark
        ? cardColor.withValues(alpha: 0.3)
        : cardColor.withValues(alpha: 0.25);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with colored icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: HugeIcon(
                  icon: icon,
                  size: 22,
                  color: cardColor,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Group Description
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Divider with card color tint
          Divider(
            color: cardColor.withValues(alpha: 0.2),
            height: 1,
            thickness: 1,
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
