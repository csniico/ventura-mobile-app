import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 8,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      selectedLabelStyle: TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.secondary,
      ),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      items: _navItems,
    );
  }

  static final List<BottomNavigationBarItem> _navItems = [
    _navItem(
      icon: HugeIcons.strokeRoundedHome01,
      label: 'Home',
    ),
    _navItem(
      icon: HugeIcons.strokeRoundedChart01,
      label: 'Sales',
    ),
    _navItem(
      icon: HugeIcons.strokeRoundedPromotion,
      label: 'Campaigns',
    ),
    _navItem(
      icon: HugeIcons.strokeRoundedCalendar03,
      label: 'Calendar',
    ),
  ];

  static BottomNavigationBarItem _navItem({
    required List<List<dynamic>> icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: HugeIcon(icon: icon, size: 24),
      ),
      label: label,
    );
  }
}
