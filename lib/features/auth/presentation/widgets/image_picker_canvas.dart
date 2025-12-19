import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class ImagePickerCanvas extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final String? label;
  final bool isLoading;

  const ImagePickerCanvas({
    super.key,
    this.imagePath,
    required this.onTap,
    required this.onRemove,
    this.label,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomPaint(
      foregroundPainter: DottedBorderPainter(
        color: colorScheme.primary.withValues(alpha: 0.9),
        gap: 6,
      ),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surface.withValues(alpha: 0.5)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: imagePath != null
            ? Stack(
                children: [
                  // Full-size image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imagePath!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Close button overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: onRemove,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: isLoading
                    ? CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: onTap,
                            iconSize: 48,
                            icon: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: isDark ? 0.2 : 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add_photo_alternate_outlined,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            label ?? 'Tap to add a logo',
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DottedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(16),
    );

    final Path path = Path()..addRRect(rrect);

    // Logic to draw dashes
    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + gap),
          paint,
        );
        distance += gap * 2;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
