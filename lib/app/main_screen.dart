import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/widgets/app_bottom_nav_bar.dart';
import 'package:ventura/core/widgets/app_drawer.dart';
import 'package:ventura/core/widgets/main_app_bar.dart';
import 'package:ventura/features/appointments/presentation/appointments.dart';
import 'package:ventura/features/home/presentation/home.dart';
import 'package:ventura/features/marketing/presentation/marketing.dart';
import 'package:ventura/features/sales/presentation/sales.dart';

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
        return const Appointments();
      case 3:
        return const Marketing();
      default:
        return const Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      key: const Key('main_screen_scaffold'),
      drawer: SafeArea(child: const AppDrawer()),
      body: SafeArea(child: RepaintBoundary(child: _buildBody())),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        key: const Key('main_screen_bottom_nav_bar'),
      ),
    );
  }
}
