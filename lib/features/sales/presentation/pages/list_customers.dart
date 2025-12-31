import 'package:flutter/material.dart';
import 'package:ventura/features/sales/presentation/pages/view_customer.dart';

class ListCustomers extends StatelessWidget {
  const ListCustomers({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        20,
        (index) => ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ViewCustomer(customerId: index + 1),
              ),
            );
          },
          leading: Icon(Icons.person),
          title: Text('Customer ${index + 1}'),
          subtitle: Text('Details for customer ${index + 1}'),
          trailing: Text('ID: CUST${1000 + index + 1}'),
        ),
      ),
    );
  }
}
