import 'package:flutter/material.dart';

class ViewCustomer extends StatelessWidget {
  const ViewCustomer({super.key, required this.customerId});
  final int customerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text(
            'View Customer Page: $customerId',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
