import 'dart:developer';

import 'package:allwork/modals/daily_date.dart';
import 'package:allwork/providers/dailydate_provider.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/menu_helpers/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class DailyDateController extends GetxController {
  final isLoading = false.obs;
  final dailyDate = Rx<DailyDate?>(null);
  final DailyDateProvider _dailyDateProvider =
      DailyDateProvider(ApiConstants.dailyDuaToken);

  final List<String> dayDifference = [
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

  String selectedDayDifference = '0';
  TextEditingController selectedDayDifferenceController =
      TextEditingController();
  late SharedPreferences prefs;

  @override
  Future<void> onInit() async {
    super.onInit();

    prefs = await SharedPreferences.getInstance();
    selectedDayDifference =
        prefs.getString('hijri_date_adjustment') ?? '0';
    selectedDayDifferenceController.text = selectedDayDifference;
    super.onInit();

    bool hasInternet = await Helpers.hasActiveInternetConnection();
    if (hasInternet) {
      fetchDailyDateFromAPI();
      log('Internet connection is active');
    } else {
      fetchDailyDateFromDB();
      log('No internet connection');
    }
  }

  Future<void> setDayDifference(String value) async {
    selectedDayDifference = value;
    prefs.setString('hijri_date_adjustment', value);
    log(value);
    fetchDailyDateFromAPI();
    update();
  }

  Future<void> fetchDailyDateFromAPI() async {
    try {
      isLoading(true);
      DailyDate fetchedDate = await _dailyDateProvider.fetchDailyDate();
      dailyDate.value = fetchedDate;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching daily date: $e');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchDailyDateFromDB() async {
    try {
      isLoading(true);
      DailyDate fetchedDate = DbServices.instance.getDailyDate();
      dailyDate.value = fetchedDate;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching daily date: $e');
      }
    } finally {
      isLoading(false);
    }
  }
}
