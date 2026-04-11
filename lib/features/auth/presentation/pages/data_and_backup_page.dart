import 'package:flutter/material.dart';
import 'package:ventura/core/presentation/widgets/ventura_app_bar/ventura_app_bar.dart';
import 'package:ventura/core/presentation/widgets/ventura_app_bar/app_bar_type.dart';

class DataAndBackupPage extends StatelessWidget {
  const DataAndBackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VenturaAppBar(
        type: AppBarType.secondary,
        title: 'Data and Backup',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            children: [Center(child: Text('No data for you to view.'))],
          ),
        ),
      ),
    );
  }
}
