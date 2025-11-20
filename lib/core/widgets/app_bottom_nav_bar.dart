import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface.withValues(),
      ),
      selectedLabelStyle: TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface.withValues(),
      ),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      items: [
        const BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedHome01),
            label: 'Home'
        ),
        const BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedSearch01),
            label: 'Search'
        ),
        const BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedUserCircle),
            label: 'Profile'
        ),
        const BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedSettings01),
            label: 'Settings'
        ),

      ],
    );
  }
}
