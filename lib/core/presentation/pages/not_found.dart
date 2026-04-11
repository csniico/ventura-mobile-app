import 'package:flutter/material.dart';
import 'package:ventura/core/presentation/widgets/ventura_app_bar/ventura_app_bar.dart';
import 'package:ventura/core/presentation/widgets/ventura_app_bar/app_bar_type.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VenturaAppBar(
        type: AppBarType.minimal,
        title: 'Page Not Found',
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
