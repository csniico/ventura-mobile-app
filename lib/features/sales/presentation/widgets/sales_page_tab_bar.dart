import 'package:flutter/material.dart';

class SalesPageTabBar extends StatelessWidget {
  final TabController controller;

  const SalesPageTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      dividerColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(128),
      indicatorColor: Theme.of(context).colorScheme.primary,
      tabs: const [
        Tab(text: 'Invoices'),
        Tab(text: 'Orders'),
        Tab(text: 'Products'),
        Tab(text: 'Customers'),
      ],
    );
  }
}
