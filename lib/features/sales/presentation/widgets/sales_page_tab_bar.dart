import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';

class SalesPageTabBar extends StatelessWidget {
  final TabController controller;

  const SalesPageTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SegmentedTabControl(
      controller: controller,
      height: 50,
      barDecoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      indicatorPadding: EdgeInsets.all(4),
      indicatorDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      tabTextColor: Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: 0.4),
      selectedTabTextColor: Theme.of(context).colorScheme.onPrimary,
      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      tabs: [
        SegmentTab(label: 'Invoices'),
        SegmentTab(label: 'Orders'),
        SegmentTab(label: 'Products'),
        SegmentTab(label: 'Customers'),
      ],
    );
  }
}
