import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final PageController controller;
  final int totalSteps;
  final Color activeColor;
  final Color inactiveColor;

  const StepProgressIndicator({
    super.key,
    required this.controller,
    required this.totalSteps,
    this.activeColor = const Color(0xFF3B82F6),
    this.inactiveColor = const Color(0xAB99B7FF),
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        // Calculate current page safely
        double currentPage = 0;
        if (controller.hasClients) {
          currentPage = controller.page ?? 0;
        }

        int displayStep = (currentPage.round()).clamp(1, totalSteps);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 24),
            Text(
              'Step $displayStep of $totalSteps',
              style: TextStyle(
                color: activeColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(totalSteps, (index) {
                return Expanded(
                  child: Container(
                    height: 8,
                    margin: EdgeInsets.only(
                      right: index == totalSteps - 1 ? 0 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: index <= currentPage.round() - 1
                          ? activeColor
                          : inactiveColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
