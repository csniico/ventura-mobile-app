import 'package:flutter/material.dart';

class EditInvoice extends StatelessWidget {
  const EditInvoice({super.key, required this.invoiceId});
  final int invoiceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text(
            'Edit Invoice Page: $invoiceId',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
