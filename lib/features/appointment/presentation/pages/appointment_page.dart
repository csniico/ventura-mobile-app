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
import 'package:ventura/features/appointment/presentation/widgets/delete_appointment_modal.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _getUserAppointments();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we just returned from navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserAppointments();
    });
  }

  void _getUserAppointments() async {
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
      final appointmentDate = appointment.startTime;
      return appointmentDate.year == day.year &&
          appointmentDate.month == day.month &&
          appointmentDate.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: BlocConsumer<AppointmentBloc, AppointmentState>(
          listener: (context, state) async {
            if (state is AppointmentErrorState) {
              ToastService.showError(state.message);
              ToastService.showSuccess('Appointment deleted successfully');
            }
            if (state is AppointmentDeleteSuccessState) {
              User? user = UserService().user;
              if (user == null) {
                Navigator.pushNamedAndRemoveUntil(context, 'newRouteName', (_) => false);
              } else {
                context.read<AppointmentBloc>().add(AppointmentGetEvent(userId: user.id));
              }
            }
          },
          builder: (context, state) {
            if (state is AppointmentLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AppointmentErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(state.message),
                  ],
                ),
              );
            }

            if (state is AppointmentGetSuccessState) {
              final appointments = state.appointments ?? [];
              final selectedDayAppointments = _getAppointmentsForDay(
                _selectedDay!,
                appointments,
              );

              return Column(
                children: [
                  _buildCalendar(appointments),
                  Divider(
                    height: 1,
                    color: Theme.brightnessOf(context) == Brightness.light
                        ? Colors.black12
                        : Colors.white12,
                  ),
                  Expanded(
                    child: _buildAppointmentList(selectedDayAppointments),
                  ),
                ],
              );
            }

            return const Center(child: Text('No appointments'));
          },
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
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
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

  Widget _buildAppointmentList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return Center(
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
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return _buildAppointmentCard(appointments[index]);
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final timeFormat = DateFormat('h:mm a');
    final startTime = timeFormat.format(appointment.startTime);
    final endTime = timeFormat.format(appointment.endTime);

    // Determine color based on time of day
    Color getCardColor() {
      final hour = appointment.startTime.hour;
      if (hour >= 5 && hour < 12) {
        // Morning: Soft blue
        return Colors.blue.shade50;
      } else if (hour >= 12 && hour < 17) {
        // Afternoon: Soft orange
        return Colors.orange.shade50;
      } else {
        // Evening/Night: Soft purple
        return Colors.purple.shade50;
      }
    }

    Color getAccentColor() {
      final hour = appointment.startTime.hour;
      if (hour >= 5 && hour < 12) {
        return Colors.blue.shade400;
      } else if (hour >= 12 && hour < 17) {
        return Colors.orange.shade400;
      } else {
        return Colors.purple.shade400;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: getCardColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: getAccentColor().withValues(alpha: 0.3)),
        ),
        child: InkWell(
          onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              '/edit-appointment',
              arguments: appointment,
            );
            // Refresh if appointment was updated
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
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: getAccentColor(),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[900],
                            ),
                          ),
                          if (appointment.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              appointment.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: getAccentColor()),
                    const SizedBox(width: 6),
                    Text(
                      '$startTime - $endTime',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
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
