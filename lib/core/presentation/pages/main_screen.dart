import 'package:flutter/material.dart';
import 'package:ventura/core/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:ventura/core/presentation/widgets/main_app_bar.dart';
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
        return const Center(child: Text("Customer"),);
      case 3:
        return const Center(child: Text("Appointment"),);
      default:
        return const Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      key: const Key('main_screen_scaffold'),
      body: SafeArea(child: RepaintBoundary(child: _buildBody())),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        key: const Key('main_screen_bottom_nav_bar'),
      ),
    );
  }
}
