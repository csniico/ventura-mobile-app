import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppIconButton extends StatefulWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressedHandler,
    this.size = 24,        // optional size
    this.color,            // optional color
  });

  final List<List<dynamic>> icon;
  final Function onPressedHandler;
  final double size;
  final Color? color;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: IconButton(
        onPressed: () => widget.onPressedHandler(),
        icon: HugeIcon(
          icon: widget.icon,
          size: widget.size,
          color: widget.color ?? Colors.black,   // fallback color
        ),
      ),
    );
  }
}
