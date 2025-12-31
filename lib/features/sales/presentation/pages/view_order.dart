import 'package:flutter/material.dart';

class ViewOrder extends StatelessWidget {
  const ViewOrder({super.key, required this.orderId});
  final int orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text(
            'View Order Page: $orderId',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
