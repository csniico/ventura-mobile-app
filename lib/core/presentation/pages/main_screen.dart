import 'package:flutter/material.dart';
import 'package:ventura/core/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:ventura/core/presentation/widgets/main_app_bar.dart';
import 'package:ventura/features/appointment/presentation/pages/appointment_page.dart';
import 'package:ventura/features/auth/presentation/pages/profile.dart';
import 'package:ventura/features/home/presentation/pages/home.dart';
import 'package:ventura/features/sales/presentation/pages/sales.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const Home();
      case 1:
        return const Sales();
      case 2:
        return const AppointmentPage();
      case 3:
        return const Profile();
      default:
        return const Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      key: const Key('main_screen_scaffold'),
      appBar: _currentIndex != 3
          ? MainAppBar()
          : AppBar(backgroundColor: Theme.of(context).colorScheme.primary),
      body: SafeArea(child: RepaintBoundary(child: _buildBody())),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        key: const Key('main_screen_bottom_nav_bar'),
      ),
    );
  }
}
