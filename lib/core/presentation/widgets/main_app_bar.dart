import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/presentation/widgets/app_icon_button.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  const MainAppBar({super.key});

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      iconTheme: IconThemeData(color: Colors.white, weight: 800),
      centerTitle: true,
      actions: [
        AppIconButton(
          size: 26,
          onPressedHandler: () {},
          icon: HugeIcons.strokeRoundedSearch01,
        ),
        AppIconButton(
          size: 26,
          onPressedHandler: () {},
          icon: HugeIcons.strokeRoundedNotification01,
        ),
      ],
    );
  }
}
