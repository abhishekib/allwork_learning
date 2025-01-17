import 'dart:developer';

import 'package:allwork/controllers/hijri_date_adjustment_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:allwork/widgets/daily_date_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class HijriDateAdjustmentView extends StatelessWidget {
  HijriDateAdjustmentView({super.key});

  final HijriDateAdjustmentController controller =
      Get.put(HijriDateAdjustmentController());

  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Hijri Date Adjustment",
              style: AppTextStyles.whiteBoldText,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              children: [
                GetBuilder<HijriDateAdjustmentController>(
                  builder: (_) => DailyDateWidget(),
                ),
                Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'Adjust the Hijri date to match the local sighting',
                          style: AppTextStyles.whiteText,
                        ),
                        const SizedBox(height: 10),
                        DropdownMenu(
                            menuStyle: MenuStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color?>(
                                        Colors.white)),
                            controller: controller.adjustmentController,
                            textStyle: AppTextStyles.whiteBoldText,
                            dropdownMenuEntries: controller.hijriDateAdjustment
                                .map((value) => DropdownMenuEntry(
                                      value: value,
                                      label: value,
                                    ))
                                .toList(),
                            onSelected: (value) {
                              controller
                                  .setSelectedAdjustment(value.toString());
                            }),
                      ],
                    )),
              ],
            ),
          )),
    );
  }
}
