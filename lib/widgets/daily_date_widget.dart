import 'dart:developer';

import 'package:allwork/controllers/daily_date_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/utils/styles.dart';

class DailyDateWidget extends StatelessWidget {
  const DailyDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final hijriDateController = Get.put(DailyDateController());

    return Obx(() {
      if (hijriDateController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      } else if (hijriDateController.dailyDate.value == null) {
        return const Center(
          child: Text(
            'No Hijri Date available',
            style: TextStyle(color: Colors.white),
          ),
        );
      } else {
        final hijriDate =
            hijriDateController.dailyDate.value?.hijriDate ?? 'No Date';
        final hijriText = hijriDateController.dailyDate.value?.event ?? '';
        final hijriColor =
            hijriDateController.dailyDate.value?.eventColor ?? '';
        Color color;
        try {
          color = Color(int.parse(hijriColor.replaceFirst('#', '0xFF')));
        } catch (e) {
          color = Colors.white; // Default color
          log("Error parsing color: $e");
        }
        log("-------------------------->$hijriColor");
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hijriDate.toString(),
                  style: AppTextStyles.whiteBoldText.copyWith(
                    fontSize: 20,
                    color: color,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  hijriText.toString(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.whiteBoldText.copyWith(
                    fontSize: 18,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
