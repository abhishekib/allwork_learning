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
        return Text(
          hijriDate.toString(),
          style: AppTextStyles.whiteBoldText.copyWith(
            fontSize: 20,
          ),
        );
      }
    });
  }
}
