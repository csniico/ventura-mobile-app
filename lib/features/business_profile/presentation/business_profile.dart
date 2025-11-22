import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/user/user_service.dart';
import 'package:ventura/core/widgets/secondary_app_bar.dart';
import 'package:ventura/core/widgets/text_component.dart';

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({super.key});

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  Future<void> _logout() async {
    final userService = UserService();
    final googleSignIn = GoogleSignIn.instance;

    await userService.signOut();
    await googleSignIn.signOut();

    if (mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/welcome', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: SecondaryAppBar(title: "Business Profile"),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Center(child: Text("Business Profile")),
            _logoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return TextButton(
      onPressed: _logout,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(color: const Color(0xFF4285F4), width: 1.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedDoor01,
              size: 20,
              strokeWidth: 3,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            TextComponent(
              text: 'Sign out',
              type: 'title',
              size: 14,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
