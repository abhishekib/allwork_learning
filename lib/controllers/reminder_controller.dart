import 'package:allwork/modals/reminder_model.dart';
import 'package:allwork/services/db_services.dart';
import 'package:get/get.dart';

class ReminderController extends GetxController {
  RxList reminders = <ReminderModel>[].obs;

  @override
  void onInit() {
   reminders(DbServices.instance.getReminders());
    super.onInit();
  }

  
}