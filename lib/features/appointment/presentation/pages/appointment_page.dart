import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(child: Text('Appointment Page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-appointment');
        },
        child: HugeIcon(icon: HugeIcons.strokeRoundedPlusSign),
      ),
    );
  }
}
