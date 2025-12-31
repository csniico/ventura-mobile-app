import 'package:flutter/material.dart';
import 'package:ventura/features/sales/presentation/pages/view_order.dart';

class ListOrders extends StatelessWidget {
  const ListOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        20,
        (index) => ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ViewOrder(orderId: index + 1),
              ),
            );
          },
          leading: Icon(Icons.shopping_cart),
          title: Text('Order ${index + 1}'),
          subtitle: Text('Details for order ${index + 1}'),
          trailing: Text('\$${(index + 1) * 150}'),
        ),
      ),
    );
  }
}
