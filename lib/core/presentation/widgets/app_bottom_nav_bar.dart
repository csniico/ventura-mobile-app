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
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.brightnessOf(context) == Brightness.dark
                ? Colors.white12
                : Colors.black12,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: onTap,
        iconSize: 34,
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        selectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: _navItems,
      ),
    );
  }

  List<BottomNavigationBarItem> get _navItems => [
    _navItem(icon: HugeIcons.strokeRoundedHome01, label: 'Dashboard'),
    _navItem(icon: HugeIcons.strokeRoundedCoins01, label: 'Sales'),
    _navItem(icon: HugeIcons.strokeRoundedCalendar03, label: 'Calendar'),
    _navItem(icon: HugeIcons.strokeRoundedUserCircle02, label: 'Profile'),
  ];

  static BottomNavigationBarItem _navItem({
    required List<List<dynamic>> icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: HugeIcon(icon: icon, size: 28),
      label: label,
    );
  }
}
