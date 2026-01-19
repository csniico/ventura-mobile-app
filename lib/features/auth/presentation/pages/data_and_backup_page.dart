import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class DataAndBackupPage extends StatelessWidget {
  const DataAndBackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8.0),
          child: const SizedBox(height: 8.0),
        ),
        title: Text(
          'Data and Backup',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
