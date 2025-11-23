import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/widgets/app_icon_button.dart';

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
      // backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      iconTheme: IconThemeData(
        color: Theme.brightnessOf(context) == Brightness.light
            ? Colors.grey[800]
            : Colors.grey[300],
      ),
      actions: [
        AppIconButton(
          onPressedHandler: () {},
          icon: HugeIcons.strokeRoundedSearch01,
        ),
        AppIconButton(
          onPressedHandler: () {},
          icon: HugeIcons.strokeRoundedNotification01,
        ),
      ],
    );
  }
}
