import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';
import 'package:ventura/features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:ventura/features/appointment/presentation/widgets/appointment_hero_header.dart';
import 'package:ventura/features/appointment/presentation/widgets/appointment_time_card.dart';
import 'package:ventura/features/appointment/presentation/widgets/collapsible_info_section.dart';
import 'package:ventura/features/appointment/presentation/widgets/delete_appointment_modal.dart';

/// A page that displays the details of an appointment with a professional,
/// hierarchical layout following UX best practices for information scanning.
///
/// The page is structured with:
/// 1. Hero Header - Title, status badge, and relative time
/// 2. Schedule Card - Date, time range, and duration
/// 3. About Section - Description and notes
/// 4. Properties Section - Collapsible recurrence and sync info
/// 5. Bottom Action Bar - Delete action with confirmation
class AppointmentDetailsPage extends StatelessWidget {
  const AppointmentDetailsPage({super.key, required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
        child: Column(
          children: [
            // Scrollable content
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Hero Header - Most prominent section
                  AppointmentHeroHeader(
                    title: appointment.title,
                    startTime: appointment.startTime,
                    endTime: appointment.endTime,
                  ),
                  const SizedBox(height: 16),

                  // 2. Schedule Card - When and how long
                  AppointmentTimeCard(
                    startTime: appointment.startTime,
                    endTime: appointment.endTime,
                  ),
                  const SizedBox(height: 16),

                  // 3. About Section - Description and Notes
                  _buildAboutSection(context),
                  const SizedBox(height: 16),

                  // 4. Properties Section - Collapsible secondary info
                  _buildPropertiesSection(context),
                  const SizedBox(height: 32),
                  _buildBottomActionBar(context),
                ],
              ),
            ),
            // 5. Bottom Action Bar
          ],
        ),
      ),
    );
  }

  /// Builds the About section containing description and notes
  Widget _buildAboutSection(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = const Color(0xFFF59E0B); // Amber for about/notes

    final hasDescription =
        appointment.description != null && appointment.description!.isNotEmpty;
    final hasNotes = appointment.notes != null && appointment.notes!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: accentColor.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedInformationCircle,
                size: 22,
                color: accentColor,
              ),
              const SizedBox(width: 12),
              Text(
                'About',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description section
          if (hasDescription) ...[
            Text(
              'Description',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              appointment.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.5,
              ),
            ),
            if (hasNotes) const SizedBox(height: 16),
          ],

          // Notes section
          if (hasNotes) ...[
            Divider(
              color: accentColor.withValues(alpha: 0.2),
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedNote,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notes',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.notes!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          // Empty state
          if (!hasDescription && !hasNotes) ...[
            Text(
              'No description or notes have been added to this appointment.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds the collapsible Properties section with recurrence and sync info
  Widget _buildPropertiesSection(BuildContext context) {
    final summaryParts = <String>[];

    // Build summary string
    if (appointment.isRecurring) {
      final freq = _formatFrequency(appointment.recurringFrequency);
      summaryParts.add(freq ?? 'Recurring');
    } else {
      summaryParts.add('One-time');
    }

    final isSynced =
        appointment.googleEventId != null &&
        appointment.googleEventId != 'none';
    summaryParts.add(isSynced ? 'Synced' : 'Not synced');

    return CollapsibleInfoSection(
      icon: HugeIcons.strokeRoundedSettings01,
      title: 'Properties',
      summary: summaryParts.join(' • '),
      accentColor: const Color(0xFF10B981),
      children: [
        // Recurrence info
        _buildPropertyRow(
          context,
          icon: HugeIcons.strokeRoundedRepeat,
          label: 'Recurrence',
          value: appointment.isRecurring
              ? _buildRecurrenceText()
              : 'This is a one-time appointment',
        ),
        const SizedBox(height: 12),

        // Sync status
        _buildPropertyRow(
          context,
          icon: HugeIcons.strokeRoundedCloudSavingDone01,
          label: 'Google Calendar',
          value: isSynced
              ? 'Synced and will appear in both apps'
              : 'Not synced with Google Calendar',
        ),
      ],
    );
  }

  /// Builds a single property row with icon, label, and value
  Widget _buildPropertyRow(
    BuildContext context, {
    required List<List<dynamic>> icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HugeIcon(
          icon: icon,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the recurrence description text
  String _buildRecurrenceText() {
    final frequency =
        _formatFrequency(appointment.recurringFrequency) ?? 'periodically';

    if (appointment.recurringUntil != null) {
      final until = DateFormat(
        'MMMM d, yyyy',
      ).format(appointment.recurringUntil!);
      return 'Repeats $frequency until $until';
    }
    return 'Repeats $frequency with no end date';
  }

  /// Builds the bottom action bar with delete button
  Widget _buildBottomActionBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.all(12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showDeleteConfirmation(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
            backgroundColor: theme.colorScheme.surfaceContainerLowest,
            side: BorderSide(color: Colors.transparent),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedDelete02,
            size: 20,
            color: theme.colorScheme.error,
          ),
          label: const Text(
            'Delete Appointment',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  /// Shows the delete confirmation modal
  void _showDeleteConfirmation(BuildContext context) {
    DeleteAppointmentModal.show(
      context: context,
      appointmentTitle: appointment.title,
      onDelete: () async {
        final userService = UserService();
        final user = await userService.getUser();

        if (user == null) {
          ToastService.showError('User not logged in');
          return;
        }

        if (context.mounted) {
          context.read<AppointmentBloc>().add(
            AppointmentDeleteEvent(
              appointmentId: appointment.id,
              businessId: appointment.businessId,
              userId: user.id,
            ),
          );
          Navigator.pop(context, true);
        }
      },
    );
  }

  /// Formats the frequency string for display
  String? _formatFrequency(String? frequency) {
    if (frequency == null) return null;
    switch (frequency) {
      case 'daily':
        return 'daily';
      case 'weekly':
        return 'weekly';
      case 'bi-weekly':
        return 'every 2 weeks';
      case 'monthly':
        return 'monthly';
      case 'bi-monthly':
        return 'every 2 months';
      case 'quarterly':
        return 'quarterly';
      case 'yearly':
        return 'yearly';
      default:
        return frequency;
    }
  }
}
