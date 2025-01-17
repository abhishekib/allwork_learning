import 'dart:developer';

import 'package:flutter/material.dart';
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
  TextEditingController adjustmentController = TextEditingController();

  late SharedPreferences prefs;

  @override
  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
    selectedAdjustment.value = prefs.getString('hijri_date_adjustment') ?? '0';
    adjustmentController.text = selectedAdjustment.value;
    super.onInit();
  }

  Future<void> setSelectedAdjustment(String value) async {
    selectedAdjustment.value = value;
    prefs.setString('hijri_date_adjustment', value);
    log(value);
    update();
  }

  void closeDialogue() {
    Get.back();
  }
}
