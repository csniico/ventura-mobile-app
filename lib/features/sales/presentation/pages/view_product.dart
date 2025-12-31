import 'package:flutter/material.dart';

class ViewProduct extends StatelessWidget {
  const ViewProduct({super.key, required this.productId});
  final int productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text(
            'View Product Page: $productId',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
