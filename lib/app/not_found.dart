import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '404 - The page you are looking for does not exist.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
