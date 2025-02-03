import 'package:allwork/controllers/reminder_controller.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReminderView extends StatelessWidget {
  ReminderView({super.key});

  var controller = Get.put(ReminderController());

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Reminders",
                style: AppTextStyles.whiteBoldTitleText,
              ),
            ),
            body: Obx(
          () => Center(
            child: controller.reminders.isEmpty
                ? Text("No reminders activated", style: AppTextStyles.whiteBoldText)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListView.builder(
                      itemCount: controller.reminders.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9.5),
                              ),
                              child: ListTile(                               
                                title: Text(
                                    TextCleanerService.cleanText(
                                        controller.reminders[index].title),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.customStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.backgroundBlue,
                                    )),
                               
                              ),
                            ),
                            const SizedBox(height: 10)
                          ],
                        );
                      },
                    ),
                  ),
          ),
        )));
  }
}
