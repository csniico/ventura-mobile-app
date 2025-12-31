import 'package:flutter/material.dart';
import 'package:ventura/features/sales/presentation/pages/view_invoice.dart';

class ListInvoices extends StatelessWidget {
  const ListInvoices({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        20,
        (index) => ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ViewInvoice(invoiceId: index),
              ),
            );
          },
          leading: Icon(Icons.receipt_long),
          title: Text('Invoice ${index + 1}'),
          subtitle: Text('Details for invoice ${index + 1}'),
          trailing: Text('\$${(index + 1) * 100}'),
        ),
      ),
    );
  }
}
