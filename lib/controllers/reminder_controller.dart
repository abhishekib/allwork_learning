import 'dart:developer';

import 'package:allwork/modals/reminder_model.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/services/local_notifications.dart';
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
    LocalNotifications.cancelNotification(reminders[index].id);
    reminders.removeAt(index);
    Get.snackbar("Deleted", "Deleted the reminder");
  }

  void openReminder(int index) {
    
  }
}
