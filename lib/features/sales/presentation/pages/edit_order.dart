import 'package:flutter/material.dart';

class EditOrder extends StatelessWidget {
  const EditOrder({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text(
            'Edit Order Page: $orderId',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
