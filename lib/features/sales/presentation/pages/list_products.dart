import 'package:flutter/material.dart';
import 'package:ventura/features/sales/presentation/pages/view_product.dart';

class ListProducts extends StatelessWidget {
  const ListProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        20,
        (index) => ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ViewProduct(productId: index + 1),
              ),
            );
          },
          leading: Icon(Icons.shopping_bag),
          title: Text('Product ${index + 1}'),
          subtitle: Text('Description for product ${index + 1}'),
          trailing: Text('\$${(index + 1) * 10}'),
        ),
      ),
    );
  }
}
