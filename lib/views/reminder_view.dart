import 'dart:developer';

import 'package:allwork/controllers/reminder_controller.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/constants.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
                    ? Text("No reminders activated",
                        style: AppTextStyles.whiteBoldText)
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.builder(
                          itemCount: controller.reminders.length,
                          itemBuilder: (context, index) {
                            DateTime localDateTime = controller
                                .reminders[index].scheduledDateTime
                                .toLocal();
                            log("weekday ${localDateTime.weekday.toString()}");
                            log("weekday from api constants ${ApiConstants.days[localDateTime.weekday].dayKey}");
                            // log("weekday from api constants ${ApiConstants.days[0].dayKey}");
                            // log("weekday from api constants ${ApiConstants.days[1].dayKey}");
                            // log("weekday from api constants ${ApiConstants.days[2].dayKey}");
                            // log("weekday from api constants ${ApiConstants.days[3].dayKey}");
                            // log("weekday from api constants ${ApiConstants.days[4].dayKey}");
                            // log("weekday from api constants ${ApiConstants.days[5].dayKey}");
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(9.5),
                                  ),
                                  child: ListTile(
                                      onTap: () {
                                        controller.openReminder(index);
                                      },
                                      title: Column(
                                        children: [
                                          Text(
                                              TextCleanerService.cleanText(
                                                  controller
                                                      .reminders[index].title),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles.customStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.backgroundBlue,
                                              )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  ApiConstants
                                                      .days[
                                                          localDateTime.weekday]
                                                      .dayKey,
                                                  style:
                                                      AppTextStyles.customStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors
                                                        .backgroundBlue,
                                                  )),
                                              Text(
                                                DateFormat('HH:mm')
                                                    .format(localDateTime)
                                                    .toString(),
                                                style:
                                                    AppTextStyles.customStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.backgroundBlue,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 10,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .removeReminder(index);
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.backgroundBlue,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .openReminder(index);
                                                },
                                                child: Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
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
