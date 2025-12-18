import 'package:flutter/material.dart';

class SalesPageTabBar extends StatelessWidget {
  const SalesPageTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelPadding: const EdgeInsets.symmetric(horizontal: 20),
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        insets: const EdgeInsets.symmetric(horizontal: 16),
      ),
      labelColor: Theme.of(context).colorScheme.primary,
      unselectedLabelColor: Colors.grey,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      dividerColor: Colors.grey[400],
      tabs: const [
        Tab(text: 'Invoices'),
        Tab(text: 'Orders'),
        Tab(text: 'Inventory'),
      ],
    );
  }
}
