import 'package:allwork/controllers/daily_date_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:allwork/widgets/daily_date_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HijriDateAdjustmentView extends StatelessWidget {
  HijriDateAdjustmentView({super.key});

  final DailyDateController controller = Get.put(DailyDateController());

  @override
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
            child: Column(children: [
              GetBuilder<DailyDateController>(
                  builder: (_) => DailyDateWidget()),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'Adjust the Hijri date to match the local sighting',
                        style: AppTextStyles.whiteText,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: DropdownMenu(
                            menuStyle: MenuStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color?>(
                                        Colors.white)),
                            controller:
                                controller.selectedDayDifferenceController,
                            textStyle: AppTextStyles.whiteBoldText,
                            dropdownMenuEntries: controller.dayDifference
                                .map((value) => DropdownMenuEntry(
                                    value: value,
                                    labelWidget: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                          child: Text(value,
                                              style: AppTextStyles.whiteText)),
                                    ),
                                    label: value))
                                .toList(),
                            onSelected: (value) {
                              controller.setDayDifference(value.toString());
                            }),
                      ),
                    ]),
              )
            ]),
          )),
    );
  }
}
