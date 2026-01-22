import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';
import 'package:ventura/features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:ventura/features/appointment/presentation/pages/appointment_details_page.dart';
import 'package:ventura/features/appointment/presentation/widgets/delete_appointment_modal.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Only fetch if we don't already have data in state
    final currentState = context.read<AppointmentBloc>().state;
    if (currentState is AppointmentGetSuccessState) {
      _appointments = currentState.appointments ?? [];
    } else {
      _getUserAppointments();
    }
  }

  Future<void> _getUserAppointments() async {
    final userService = UserService();
    final user = await userService.getUser();

    if (!mounted) return;

    if (user == null) {
      ToastService.showError('User not logged in, navigating to sign-in page');
      Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (_) => false);
      return;
    }
    context.read<AppointmentBloc>().add(AppointmentGetEvent(userId: user.id));
  }

  List<Appointment> _getAppointmentsForDay(
    DateTime day,
    List<Appointment> appointments,
  ) {
    return appointments.where((appointment) {
      // Check if this is a non-recurring appointment on this day
      final appointmentDate = appointment.startTime;
      final isSameDate =
          appointmentDate.year == day.year &&
          appointmentDate.month == day.month &&
          appointmentDate.day == day.day;

      if (!appointment.isRecurring) {
        return isSameDate;
      }

      // For recurring appointments, check if this day falls within the pattern
      return _isRecurringAppointmentOnDay(appointment, day);
    }).toList();
  }

  /// Check if a recurring appointment falls on the given day
  bool _isRecurringAppointmentOnDay(Appointment appointment, DateTime day) {
    final startDate = appointment.startTime;
    final untilDate = appointment.recurringUntil;
    final frequency = appointment.recurringFrequency;

    // If no frequency or until date, only show on start date
    if (frequency == null || untilDate == null) {
      return _isSameDay(startDate, day);
    }

    // Day must be on or after start date
    if (day.isBefore(
      DateTime(startDate.year, startDate.month, startDate.day),
    )) {
      return false;
    }

    // Day must be on or before until date
    if (day.isAfter(DateTime(untilDate.year, untilDate.month, untilDate.day))) {
      return false;
    }

    // Check if day matches based on frequency
    switch (frequency) {
      case 'daily':
        return true; // Every day within range
      case 'weekly':
        // Same day of week as start date
        return day.weekday == startDate.weekday;
      case 'bi-weekly':
        // Same day of week, every 2 weeks
        if (day.weekday != startDate.weekday) return false;
        final daysDiff = day.difference(startDate).inDays;
        final weeksDiff = daysDiff ~/ 7;
        return weeksDiff % 2 == 0;
      case 'monthly':
        // Same day of month
        return day.day == startDate.day;
      case 'bi-monthly':
        // Same day of month, every 2 months
        if (day.day != startDate.day) return false;
        final monthsDiff =
            (day.year - startDate.year) * 12 + (day.month - startDate.month);
        return monthsDiff % 2 == 0;
      case 'yearly':
        // Same month and day
        return day.month == startDate.month && day.day == startDate.day;
      default:
        return _isSameDay(startDate, day);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: BlocListener<AppointmentBloc, AppointmentState>(
          listener: (context, state) async {
            if (state is AppointmentLoadingState) {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
            } else if (state is AppointmentErrorState) {
              setState(() {
                _isLoading = false;
                _errorMessage = state.message;
              });
              ToastService.showError(state.message);
            } else if (state is AppointmentGetSuccessState) {
              setState(() {
                _isLoading = false;
                _errorMessage = null;
                _appointments = state.appointments ?? [];
              });
            } else if (state is AppointmentDeleteSuccessState) {
              User? user = UserService().user;
              if (user == null) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/sign-in',
                  (_) => false,
                );
              } else {
                context.read<AppointmentBloc>().add(
                  AppointmentGetEvent(userId: user.id),
                );
              }
            }
          },
          child: Column(
            children: [
              _buildCalendar(_appointments),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: _getUserAppointments,
                  child: _buildAppointmentListArea(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-appointment');
        },
        child: const HugeIcon(icon: HugeIcons.strokeRoundedPlusSign),
      ),
    );
  }

  Widget _buildCalendar(List<Appointment> appointments) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarFormat: CalendarFormat.month,
        eventLoader: (day) => _getAppointmentsForDay(day, appointments),
        calendarStyle: CalendarStyle(
          markersMaxCount: 3,
          markerDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        daysOfWeekHeight: 45,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
      ),
    );
  }

  Widget _buildAppointmentListArea() {
    final selectedDayAppointments = _getAppointmentsForDay(
      _selectedDay!,
      _appointments,
    );

    // Show loading indicator
    if (_isLoading && _appointments.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 100),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    // Show error message
    if (_errorMessage != null && _appointments.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 60),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(_errorMessage!),
                const SizedBox(height: 16),
                Text(
                  'Pull down to retry',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Show empty state
    if (selectedDayAppointments.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 60),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendar03,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No appointments for this day',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Show appointments list
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: selectedDayAppointments.length,
      itemBuilder: (context, index) {
        return _buildAppointmentCard(selectedDayAppointments[index]);
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('h:mm a');
    final startTime = timeFormat.format(appointment.startTime);
    final endTime = timeFormat.format(appointment.endTime);

    // Calculate duration string
    final duration = appointment.endTime.difference(appointment.startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    String durationString = '';
    if (hours > 0) durationString += '$hours hr ';
    if (minutes > 0) durationString += '$minutes min';
    durationString = durationString.trim();

    // Calculate relative time (Time Left)
    String timeLeft = '';
    final now = DateTime.now();
    // Simple status computation for relative time
    if (now.isAfter(appointment.endTime)) {
      timeLeft = 'Completed';
    } else if (now.isAfter(appointment.startTime) &&
        now.isBefore(appointment.endTime)) {
      final remaining = appointment.endTime.difference(now);
      if (remaining.inMinutes < 60) {
        timeLeft = '${remaining.inMinutes} min remaining';
      } else {
        timeLeft = '${remaining.inHours} hr remaining';
      }
    } else {
      final difference = appointment.startTime.difference(now);
      if (difference.inDays == 0 && appointment.startTime.day == now.day) {
        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;
        if (hours == 0) {
          timeLeft = 'Starts in $minutes min';
        } else {
          timeLeft = 'Starts in $hours hr';
        }
      } else if (difference.inDays == 1 ||
          (difference.inDays == 0 && appointment.startTime.day != now.day)) {
        timeLeft = 'Tomorrow';
      } else {
        timeLeft = 'In ${difference.inDays} days';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: theme.colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AppointmentDetailsPage(appointment: appointment),
              ),
            );
            if (result == true && mounted) {
              _getUserAppointments();
            }
          },
          onLongPress: () {
            DeleteAppointmentModal.show(
              context: context,
              appointmentTitle: appointment.title,
              onDelete: () {
                _deleteAppointment(appointment);
                _getUserAppointments();
              },
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primary Title: Time Left
                Text(
                  timeLeft,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle: Meeting Title
                Text(
                  appointment.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                // Footer: Time | Duration
                Row(
                  children: [
                    Text(
                      '$startTime - $endTime',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '|',
                        style: TextStyle(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                    Text(
                      durationString,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteAppointment(Appointment appointment) async {
    final userService = UserService();
    final user = await userService.getUser();

    if (!mounted) return;

    if (user == null) {
      ToastService.showError('User not logged in');
      return;
    }

    context.read<AppointmentBloc>().add(
      AppointmentDeleteEvent(
        appointmentId: appointment.id,
        businessId: appointment.businessId,
        userId: user.id,
      ),
    );
  }
}
