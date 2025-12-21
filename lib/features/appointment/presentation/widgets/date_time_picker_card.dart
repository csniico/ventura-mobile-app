import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class DateTimePickerCard extends StatelessWidget {
  const DateTimePickerCard({
    super.key,
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final List<List<dynamic>> icon;
  final String? subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final darkGrey = Theme.brightnessOf(context) == Brightness.light
        ? Colors.black54
        : Colors.white54;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.brightnessOf(context) == Brightness.light
              ? Colors.grey[200]
              : const Color(0xFF2C2C2C),
          border: Border.all(
            color: Theme.brightnessOf(context) == Brightness.light
                ? Color(0xFFD4D4D4)
                : Color(0xFF3A3A3A),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HugeIcon(icon: icon, size: 28, color: Colors.grey),
              SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: darkGrey)),
                  SizedBox(height: 5),
                  Text(
                    subtitle ?? '',
                    style: TextStyle(color: darkGrey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
