import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/config/routes.dart';
import 'package:ventura/core/presentation/widgets/user_avatar.dart';
import 'package:ventura/core/services/user_service.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  MainAppBar({super.key});

  final AppRoutes _appRoutes = AppRoutes.instance;
  final UserService _userService = UserService();

  String optimizeText(String title) {
    if (title.length > 15) {
      return '${title.substring(0, 12)}...';
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(12.0),
        child: const SizedBox(height: 12.0),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: UserAvatar(
          profileHeight: 24.0,
          imageUrl: _userService.user?.avatarUrl,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            optimizeText(_userService.user?.firstName ?? 'Ventura'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          Text(
            optimizeText(_userService.user?.business?.name ?? 'ventura'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, _appRoutes.search);
            },
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
