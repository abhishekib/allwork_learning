import 'dart:developer';

import 'package:allwork/controllers/daily_date_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/utils/styles.dart';

class DailyDateWidget extends StatelessWidget {
  const DailyDateWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      log("Reconstruction");
      
    final hijriDateController = Get.put(DailyDateController());

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
        Color parseColor(String hijriColor) {
          try {
            if (hijriColor.startsWith('#')) {
              if (hijriColor.length == 4) {
                hijriColor =
                    '#${hijriColor[1]}${hijriColor[1]}${hijriColor[2]}${hijriColor[2]}${hijriColor[3]}${hijriColor[3]}';
              }
            } else {
              throw FormatException('Invalid color format: $hijriColor');
            }

            String colorHex = hijriColor.replaceFirst('#', '0xFF');
            int parsedColor = int.parse(colorHex);
            return Color(parsedColor);
          } catch (e) {
            log("Error parsing color: $e");
            return Color(0xFF1b8415);
          }
        }

        // log("-------------------------->$hijriColor");
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
                    color: Color(0xFF1b8415),
                  ),
                ),
                SizedBox(height: 10),
                Container( color: Colors.white,
                  child: Visibility(
                    visible: hijriText.isNotEmpty,
                    child: Text(
                      '(${hijriText.toString()})',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.whiteBoldText.copyWith(
                        fontSize: 18,
                        color: parseColor(hijriColor),
                      ),
                    ),
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
