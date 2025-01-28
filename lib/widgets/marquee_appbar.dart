
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:allwork/utils/styles.dart';

class MarqueeTextWidget extends StatelessWidget {
  final List<String> marqueeTexts;

  const MarqueeTextWidget({super.key, required this.marqueeTexts});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundBlue, // Background color for the container
      height: 36.0,
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Marquee(
                text: TextCleanerService.cleanText(marqueeTexts.join(
                    '   ||   ')), // Joining all the text items with separator
                style:
                    AppTextStyles.whiteText, // Custom TextStyle for the marquee
                blankSpace: 50.0,
                velocity: 30.0,
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: const Duration(seconds: 1),
                decelerationDuration: const Duration(milliseconds: 500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
