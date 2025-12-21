import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/common/utils/date_time_util.dart';
import 'package:ventura/features/appointment/presentation/widgets/calendar_widget.dart';
import 'package:ventura/features/appointment/presentation/widgets/date_time_picker_card.dart';
import 'package:ventura/features/appointment/presentation/widgets/text_input_component.dart';
import 'package:ventura/features/appointment/presentation/widgets/time_list_picket.dart';

class CreateAppointmentPage extends StatefulWidget {
  const CreateAppointmentPage({super.key});

  @override
  State<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  bool showCalendar = false;
  bool isRecurring = false;
  TimeOfDay time = TimeOfDay.now();

  void handleCalendarTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(children: [CalendarWidget()]);
      },
    );
  }

  void handleTimeTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            TimeListPicker(
              selectedTime: time,
              onChanged: (time) {
                debugPrint(time.toString());
                setState(() {
                  this.time = time;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkGrey = Theme.brightnessOf(context) == Brightness.light
        ? Colors.black54
        : Colors.white54;
    final lightGrey = Theme.brightnessOf(context) == Brightness.light
        ? Colors.black12
        : Colors.white12;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add appointment', style: TextStyle(fontSize: 16)),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () {},
              child: Text('Save', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInputComponent(
                    title: 'Title',
                    hintText: 'eg. Meeting with new customer',
                    onSaved: (value) {},
                    isRequired: true,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Date & Time',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  DateTimePickerCard(
                    title: 'Date',
                    icon: HugeIcons.strokeRoundedCalendar01,
                    subtitle: formatWithSuffix(DateTime.now()),
                    onTap: () {
                      handleCalendarTap();
                    },
                  ),
                  SizedBox(height: 10),
                  DateTimePickerCard(
                    title: 'Time',
                    icon: HugeIcons.strokeRoundedClock01,
                    subtitle: '10:00 AM',
                    onTap: () {
                      handleTimeTap();
                    },
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Repeat?',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                      subtitle: formatWithSuffix(DateTime.now()),
                      onTap: () {},
                    ),
                    SizedBox(height: 10),
                    DateTimePickerCard(
                      title: 'Time',
                      icon: HugeIcons.strokeRoundedClock01,
                      subtitle: '10:00 AM',
                      onTap: () {},
                    ),
                    SizedBox(height: 10),
                    TextInputComponent(
                      title: 'Frequency',
                      hintText:
                          'eg. daily, weekly, monthly, two-weeks, two-months',
                      onSaved: (value) {},
                    ),
                    SizedBox(height: 30),
                  ],

                  TextInputComponent(
                    title: 'Description',
                    hintText: 'The meeting is about ...',
                    onSaved: (value) {},
                    maxLength: 2000,
                    maxLines: null,
                    minLines: 4,
                  ),
                  TextInputComponent(
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
    );
  }
}
