import 'package:flutter/material.dart';

class ViewInvoice extends StatelessWidget {
  const ViewInvoice({super.key, required this.invoiceId});
  final int invoiceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text(
            'View Invoice Page: $invoiceId',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
