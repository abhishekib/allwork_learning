import 'dart:developer';

import 'package:allwork/entities/bookmark_reminder_deep_link_data_entity.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/reminder_model.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/helpers.dart';
import 'package:allwork/views/category_detail_view.dart';
import 'package:get/get.dart';

class ReminderController extends GetxController {
  RxList<ReminderModel> reminders = <ReminderModel>[].obs;

  @override
  void onInit() {
    reminders(DbServices.instance.getReminders());
    super.onInit();
  }

  void removeReminder(int index) {
    log("index to be removed and cancelled ${index.toString()}");
    DbServices.instance.deleteReminder(reminders[index].id);
    //LocalNotificationServices.cancelNotification(reminders[index].id);
    reminders.removeAt(index);
    Get.snackbar("Deleted", "Deleted the reminder");
  }

  void openReminder(int index) {
    ReminderDataEntity reminderDataEntity = DbServices.instance.getReminderData(
      reminders[index].title,
    )!;

    
    Category category = CategoryHelpers.toCategory(reminderDataEntity.category!);

    Get.to(
      () => const CategoryDetailView(),
      arguments: {
        'category': category,
        'language': 'English',
        'menuItem': category.category,
      },
    );
  }
}
