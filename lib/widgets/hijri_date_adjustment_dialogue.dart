import 'dart:developer';

import 'package:allwork/controllers/hijri_date_adjustment_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HijriDate extends StatefulWidget {
  const HijriDate({super.key});

  @override
  HijriDateState createState() => HijriDateState();
}

class HijriDateState extends State<HijriDate> {
  HijriDateAdjustmentController controller =
      Get.put(HijriDateAdjustmentController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Hijri Date Adjustment',
                        style: AppTextStyles.whiteBoldTitleText,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Adjust the Hijri date to match the local sighting',
                        style: AppTextStyles.whiteText,
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => DropdownButton(
                            value: controller.selectedAdjustment.value,
                            style: AppTextStyles.whiteBoldText,
                            selectedItemBuilder: (context) {
                              return controller.hijriDateAdjustment
                                  .map((value) => Center(
                                        child: Text(
                                          value,
                                          style: AppTextStyles.whiteBoldText,
                                        ),
                                      ))
                                  .toList();
                            },
                            items: controller.hijriDateAdjustment
                                .map((value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: AppTextStyles.blueBoldText,
                                    )))
                                .toList(),
                            onChanged: (value) {
                              controller
                                  .setSelectedAdjustment(value.toString());
                            }),
                      ),
                    ],
                  )))),
    );
  }
}
