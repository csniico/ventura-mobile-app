import 'package:flutter/material.dart';

class TextComponent extends StatelessWidget {
  const TextComponent({
    super.key,
    required this.text,
    required this.type,
    this.color,
    this.size,
  });

  final String text;

  /// e.g.: "title", "subtitle", "body", "caption"
  final String type;

  /// Optional override color
  final Color? color;

  /// Optional override font size
  final double? size;

  @override
  Widget build(BuildContext context) {
    final style = _getTextStyle(context);

    return Text(
      text,
      style: style,
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    // Default style
    TextStyle base = const TextStyle(
      fontFamily: 'Inter',
    );

    switch (type) {
      case 'title':
        base = base.copyWith(
          fontSize: size ?? 24,
          fontWeight: FontWeight.bold,
        );
        break;

      case 'subtitle':
        base = base.copyWith(
          fontSize: size ?? 18,
          fontWeight: FontWeight.w600,
        );
        break;

      case 'body':
        base = base.copyWith(
          fontSize: size ?? 14,
          fontWeight: FontWeight.w400,
        );
        break;

      case 'caption':
        base = base.copyWith(
          fontSize: size ?? 12,
          fontWeight: FontWeight.w300,
        );
        break;

      default:
        base = base.copyWith(
          fontSize: size ?? 14,
          fontWeight: FontWeight.normal,
        );
    }

    return base.copyWith(
      color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
    );
  }
}
