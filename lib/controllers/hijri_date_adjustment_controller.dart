import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HijriDateAdjustmentController extends GetxController {
  final List<String> hijriDateAdjustment = [
    '-4',
    '-3',
    '-2',
    '-1',
    '0',
    '1',
    '2',
    '3',
    '4'
  ];

  RxString selectedAdjustment = RxString('0');

  late SharedPreferences prefs;

  @override
  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
    selectedAdjustment.value = prefs.getString('hijri_date_adjustment') ?? '0';
    super.onInit();
  }

  Future<void> setSelectedAdjustment(String value) async {
    selectedAdjustment.value = value;
    prefs.setString('hijri_date_adjustment', value);
    log(value);
  }

  void closeDialogue() {
    Get.back();
  }
}
