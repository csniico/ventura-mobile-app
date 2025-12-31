import 'package:flutter/material.dart';

class EditProduct extends StatelessWidget {
  const EditProduct({super.key, required this.productId});
  final int productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text(
            'Edit Product Page: $productId',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
