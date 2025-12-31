import 'package:flutter/material.dart';

class EditCustomer extends StatelessWidget {
  const EditCustomer({super.key, required this.customerId});
  final int customerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text(
            'Edit Customer Page: $customerId',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
