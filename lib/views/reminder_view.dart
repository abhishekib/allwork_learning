import 'package:allwork/controllers/bookmark_controller.dart';
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
            body: Center(
                child: Text("Reminders under construction",
                    style: AppTextStyles.whiteBoldText))));
  }
}
