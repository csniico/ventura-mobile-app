import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/common/utils/date_time_util.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:ventura/features/appointment/presentation/widgets/calendar_widget.dart';
import 'package:ventura/features/appointment/presentation/widgets/date_time_picker_card.dart';
import 'package:ventura/features/appointment/presentation/widgets/text_input_component.dart';
import 'package:ventura/features/appointment/presentation/widgets/time_list_picker.dart';

class CreateAppointmentPage extends StatefulWidget {
  const CreateAppointmentPage({super.key});

  @override
  State<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  bool showCalendar = false;
  bool isRecurring = false;

  // Text controllers for form inputs
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  // startTime
  DateTime selectedStartDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();

  // End time
  DateTime selectedEndDate = DateTime.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  // repeat until time
  DateTime selectedRepeatUntilDate = DateTime.now();
  TimeOfDay selectedRepeatUntilTime = TimeOfDay.now();

  // Frequency for recurring appointments
  String? selectedFrequency;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Combine date and time into DateTime
  DateTime _combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // Convert UI frequency string to backend format
  String? _getBackendFrequency(String? frequency) {
    if (frequency == null) return null;
    switch (frequency) {
      case 'Daily':
        return 'daily';
      case 'Weekly':
        return 'weekly';
      case 'Bi-Weekly':
        return 'bi-weekly';
      case 'Monthly':
        return 'monthly';
      case 'Bi-Monthly':
        return 'bi-monthly';
      case 'Yearly':
        return 'yearly';
      default:
        return null;
    }
  }

  // Submit form via BLoC
  void _saveAppointment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final startDateTime = _combineDateTime(
        selectedStartDate,
        selectedStartTime,
      );
      final endDateTime = _combineDateTime(selectedEndDate, selectedEndTime);

      final userService = UserService();
      final user = await userService.getUser();

      if (user == null) {
        ToastService.showError('User not logged in');
        return;
      }

      DateTime? recurringUntil;
      String? recurringFrequency;
      if (isRecurring && selectedFrequency != null) {
        recurringUntil = _combineDateTime(
          selectedRepeatUntilDate,
          selectedRepeatUntilTime,
        );
        recurringFrequency = _getBackendFrequency(selectedFrequency);
      }

      // Dispatch event to BLoC
      if (mounted) {
        context.read<AppointmentBloc>().add(
          AppointmentCreateEvent(
            title: _titleController.text,
            startTime: startDateTime,
            endTime: endDateTime,
            isRecurring: isRecurring,
            userId: user.id,
            businessId: user.businessId,
            description: _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
            recurringUntil: recurringUntil,
            recurringFrequency: recurringFrequency,
          ),
        );
      }
    }
  }

  void handleCalendarTap(
    DateTime initialDate,
    bool isEndDate,
    ValueChanged<DateTime> onDateChanged,
  ) async {
    // Determine the earliest selectable date based on context
    DateTime firstDay;
    if (isEndDate) {
      firstDay = selectedStartDate;
    } else if (identical(onDateChanged, (v) => selectedRepeatUntilDate = v)) {
      // For repeat until date, must be after end date
      firstDay = selectedEndDate;
    } else {
      firstDay = DateTime.now();
    }

    final result = await CalendarWidget.show(
      context,
      initialDate,
      firstDay: firstDay,
    );

    if (result != null) {
      setState(() {
        onDateChanged(result);

        // Auto-fix: If start date moved past end date, push end date to match start
        if (!isEndDate && selectedStartDate.isAfter(selectedEndDate)) {
          selectedEndDate = selectedStartDate;
        }

        // Auto-fix: If end date moved past repeat until date (only if recurring is enabled)
        if (isRecurring &&
            isEndDate &&
            selectedEndDate.isAfter(selectedRepeatUntilDate)) {
          selectedRepeatUntilDate = selectedEndDate;
        }
      });
    }
  }

  void handleTimeTap(
    TimeOfDay initialTime,
    bool isEndTime,
    ValueChanged<TimeOfDay> onTimeChanged,
  ) async {
    bool isSameDay =
        selectedStartDate.year == selectedEndDate.year &&
        selectedStartDate.month == selectedEndDate.month &&
        selectedStartDate.day == selectedEndDate.day;

    bool isRepeatUntilSameDayAsEnd =
        selectedEndDate.year == selectedRepeatUntilDate.year &&
        selectedEndDate.month == selectedRepeatUntilDate.month &&
        selectedEndDate.day == selectedRepeatUntilDate.day;

    // Determine if this is the repeat until time picker
    bool isRepeatUntilTime = identical(
      onTimeChanged,
      (v) => selectedRepeatUntilTime = v,
    );

    final result = await TimeListPicker.show(
      context,
      initialTime,
      minTime: (isEndTime && isSameDay)
          ? selectedStartTime
          : (isRecurring && isRepeatUntilTime && isRepeatUntilSameDayAsEnd)
          ? selectedEndTime
          : null,
    );

    if (result != null) {
      setState(() {
        onTimeChanged(result);

        // Auto-fix: If Start Time is pushed past End Time on the same day
        if (!isEndTime && !isRepeatUntilTime && isSameDay) {
          if (result.hour > selectedEndTime.hour ||
              (result.hour == selectedEndTime.hour &&
                  result.minute >= selectedEndTime.minute)) {
            // Set end time to 30 mins after start
            selectedEndTime = TimeOfDay(
              hour: result.hour,
              minute: result.minute + 30,
            );
          }
        }

        // Auto-fix: If End Time is pushed past Repeat Until Time on the same day (only if recurring)
        if (isRecurring && isEndTime && isRepeatUntilSameDayAsEnd) {
          if (result.hour > selectedRepeatUntilTime.hour ||
              (result.hour == selectedRepeatUntilTime.hour &&
                  result.minute >= selectedRepeatUntilTime.minute)) {
            // Set repeat until time to match end time
            selectedRepeatUntilTime = result;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentCreateSuccessState) {
          ToastService.showSuccess('Appointment created successfully');
          // Return true to indicate success
          context.read<AppointmentBloc>().add(
            AppointmentGetEvent(
              userId: state.appointment.userId,
              businessId: state.appointment.businessId,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is AppointmentErrorState) {
          ToastService.showError(state.message);
        }
      },
      child: Scaffold(
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
            'Add appointment',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextInputComponent(
                      controller: _titleController,
                      title: 'Title',
                      hintText: 'eg. Meeting with new customer',
                      onSaved: (value) {},
                      isRequired: true,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'When does it start?',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    DateTimePickerCard(
                      title: 'Date',
                      icon: HugeIcons.strokeRoundedCalendar01,
                      subtitle: formatWithSuffix(selectedStartDate),
                      onTap: () => handleCalendarTap(
                        selectedStartDate,
                        false,
                        (v) => selectedStartDate = v,
                      ),
                    ),
                    SizedBox(height: 10),
                    DateTimePickerCard(
                      title: 'Time',
                      icon: HugeIcons.strokeRoundedClock01,
                      subtitle: selectedStartTime.format(context),
                      onTap: () {
                        // Pass 'true' for isEndTime to trigger the validation logic
                        handleTimeTap(selectedStartTime, false, (value) {
                          selectedStartTime = value;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      'When does it end?',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    DateTimePickerCard(
                      title: 'Date',
                      icon: HugeIcons.strokeRoundedCalendar01,
                      subtitle: formatWithSuffix(selectedEndDate),
                      onTap: () => handleCalendarTap(
                        selectedEndDate,
                        true,
                        (v) => selectedEndDate = v,
                      ),
                    ),
                    SizedBox(height: 10),
                    DateTimePickerCard(
                      title: 'Time',
                      icon: HugeIcons.strokeRoundedClock01,
                      subtitle: selectedEndTime.format(context),
                      onTap: () {
                        // Pass 'true' for isEndTime to trigger the validation logic
                        handleTimeTap(selectedEndTime, true, (value) {
                          selectedEndTime = value;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Repeat?',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      trackOutlineColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      inactiveThumbColor: Colors.grey[200],
                      title: Text(
                        'Should this appointment be recurring?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      value: isRecurring,
                      onChanged: (value) {
                        setState(() {
                          isRecurring = !isRecurring;

                          if (isRecurring) {
                            // When enabling recurring, sync repeat until date/time with end date/time
                            selectedRepeatUntilDate = selectedEndDate;
                            selectedRepeatUntilTime = selectedEndTime;
                            // Set default frequency
                            selectedFrequency = 'Daily';
                          } else {
                            // When disabling recurring, reset frequency and repeat until date
                            selectedFrequency = null;
                            selectedRepeatUntilDate = DateTime.now();
                            selectedRepeatUntilTime = TimeOfDay.now();
                          }
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    if (isRecurring) ...[
                      Text(
                        'Repeat Until',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      DateTimePickerCard(
                        title: 'Date',
                        icon: HugeIcons.strokeRoundedCalendar01,
                        subtitle: formatWithSuffix(selectedRepeatUntilDate),
                        onTap: () => handleCalendarTap(
                          selectedRepeatUntilDate,
                          false,
                          (v) => selectedRepeatUntilDate = v,
                        ),
                      ),
                      SizedBox(height: 10),
                      DateTimePickerCard(
                        title: 'Time',
                        icon: HugeIcons.strokeRoundedClock01,
                        subtitle: selectedRepeatUntilTime.format(context),
                        onTap: () => handleTimeTap(
                          selectedRepeatUntilTime,
                          false,
                          (value) => selectedRepeatUntilTime = value,
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Frequency',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: selectedFrequency,
                            isExpanded: false,
                            menuMaxHeight: 300,
                            decoration: InputDecoration(
                              hintText: 'Select frequency',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items:
                                [
                                  'Daily',
                                  'Weekly',
                                  'Bi-Weekly',
                                  'Monthly',
                                  'Bi-Monthly',
                                  'Quarterly',
                                  'Yearly',
                                ].map((String frequency) {
                                  return DropdownMenuItem<String>(
                                    value: frequency,
                                    child: Text(frequency),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedFrequency = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],

                    TextInputComponent(
                      controller: _descriptionController,
                      title: 'Description',
                      hintText: 'The meeting is about ...',
                      onSaved: (value) {},
                      maxLength: 2000,
                      maxLines: null,
                      minLines: 4,
                    ),
                    TextInputComponent(
                      controller: _notesController,
                      title: 'Notes',
                      hintText: "It's important to remember ...",
                      onSaved: (value) {},
                      maxLength: 2000,
                      maxLines: null,
                      minLines: 4,
                    ),
                    SizedBox(height: 40),
                    BlocBuilder<AppointmentBloc, AppointmentState>(
                      builder: (context, state) {
                        final isLoading = state is AppointmentLoadingState;
                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => _saveAppointment(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Create Appointment',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
