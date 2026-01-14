import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/common/utils/date_time_util.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';
import 'package:ventura/features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:ventura/features/appointment/presentation/widgets/calendar_widget.dart';
import 'package:ventura/features/appointment/presentation/widgets/date_time_picker_card.dart';
import 'package:ventura/features/appointment/presentation/widgets/text_input_component.dart';
import 'package:ventura/features/appointment/presentation/widgets/time_list_picker.dart';

class EditAppointmentPage extends StatefulWidget {
  final Appointment appointment;

  const EditAppointmentPage({super.key, required this.appointment});

  @override
  State<EditAppointmentPage> createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  bool showCalendar = false;
  late bool isRecurring;

  // Text controllers for form inputs
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _notesController;

  // startTime
  late DateTime selectedStartDate;
  late TimeOfDay selectedStartTime;

  // End time
  late DateTime selectedEndDate;
  late TimeOfDay selectedEndTime;

  // repeat until time
  late DateTime? selectedRepeatUntilDate;
  late TimeOfDay selectedRepeatUntilTime;

  // Frequency for recurring appointments
  String? selectedFrequency;

  @override
  void initState() {
    super.initState();

    // Initialize with appointment data
    _titleController = TextEditingController(text: widget.appointment.title);
    _descriptionController = TextEditingController(
      text: widget.appointment.description ?? '',
    );
    _notesController = TextEditingController(
      text: widget.appointment.notes ?? '',
    );

    // Initialize dates and times
    selectedStartDate = widget.appointment.startTime;
    selectedStartTime = TimeOfDay.fromDateTime(widget.appointment.startTime);
    selectedEndDate = widget.appointment.endTime;
    selectedEndTime = TimeOfDay.fromDateTime(widget.appointment.endTime);

    // Initialize recurring settings
    isRecurring = widget.appointment.isRecurring;

    if (isRecurring && widget.appointment.recurringUntil != null) {
      selectedRepeatUntilDate = widget.appointment.recurringUntil!;
      selectedRepeatUntilTime = TimeOfDay.fromDateTime(
        widget.appointment.recurringUntil!,
      );
      selectedFrequency = _getUIFrequency(
        widget.appointment.recurringFrequency,
      );
    } else {
      selectedRepeatUntilDate = DateTime.now();
      selectedRepeatUntilTime = TimeOfDay.now();
      selectedFrequency = null;
    }
  }

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

  // Convert backend frequency to UI string
  String? _getUIFrequency(String? frequency) {
    if (frequency == null) return null;
    switch (frequency) {
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      case 'bi-weekly':
        return 'Bi-Weekly';
      case 'monthly':
        return 'Monthly';
      case 'bi-monthly':
        return 'Bi-Monthly';
      case 'yearly':
        return 'Yearly';
      default:
        return null;
    }
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
  void _updateAppointment() async {
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
        if (mounted) {
          ToastService.showError('User not logged in');
        }
        return;
      }

      DateTime? recurringUntil;
      String? recurringFrequency;
      if (isRecurring && selectedFrequency != null) {
        recurringUntil = _combineDateTime(
          selectedRepeatUntilDate!,
          selectedRepeatUntilTime,
        );
        recurringFrequency = _getBackendFrequency(selectedFrequency);
      }

      // Dispatch event to BLoC
      if (mounted) {
        context.read<AppointmentBloc>().add(
          AppointmentUpdateEvent(
            appointmentId: widget.appointment.id,
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
      // For start date, allow selecting from 2 years ago (to support editing old appointments)
      firstDay = DateTime.now().subtract(Duration(days: 730));
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
            selectedEndDate.isAfter(selectedRepeatUntilDate!)) {
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
        selectedEndDate.year == selectedRepeatUntilDate?.year &&
        selectedEndDate.month == selectedRepeatUntilDate?.month &&
        selectedEndDate.day == selectedRepeatUntilDate?.day;

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
        if (state is AppointmentUpdateSuccessState) {
          ToastService.showSuccess('Appointment updated successfully');
          // Return true to indicate success
          Navigator.pop(context, true);
        } else if (state is AppointmentErrorState) {
          ToastService.showError(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit appointment', style: TextStyle(fontSize: 16)),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: BlocBuilder<AppointmentBloc, AppointmentState>(
                builder: (context, state) {
                  if (state is AppointmentLoadingState) {
                    return Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  return TextButton(
                    onPressed: _updateAppointment,
                    child: Text('Save', style: TextStyle(fontSize: 16)),
                  );
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        Theme.brightnessOf(context) == Brightness.light
                            ? Colors.grey[400]!
                            : Colors.grey,
                      ),
                      inactiveThumbColor:
                          Theme.brightnessOf(context) == Brightness.light
                          ? Colors.grey[400]!
                          : Colors.grey,
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
                        subtitle: formatWithSuffix(selectedRepeatUntilDate!),
                        onTap: () => handleCalendarTap(
                          selectedRepeatUntilDate!,
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
