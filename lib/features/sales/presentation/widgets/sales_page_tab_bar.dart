import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';

class SalesPageTabBar extends StatelessWidget {
  const SalesPageTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SegmentedTabControl(
      barDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      indicatorPadding: EdgeInsets.all(4),
      indicatorDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      tabTextColor: Theme.of(context).colorScheme.onSurfaceVariant,
      selectedTabTextColor: Theme.of(context).colorScheme.onPrimary,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      tabs: [
        SegmentTab(label: 'Invoices'),
        SegmentTab(label: 'Orders'),
        SegmentTab(label: 'Products'),
        SegmentTab(label: 'Customers'),
      ],
    );
  }
}
