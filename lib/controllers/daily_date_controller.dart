import 'dart:developer';

import 'package:allwork/modals/daily_date.dart';
import 'package:allwork/providers/dailydate_provider.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/menu_helpers/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

class DailyDateController extends GetxController {
  final isLoading = false.obs;
  final dailyDate = Rx<DailyDate?>(null);
  final DailyDateProvider _dailyDateProvider =
      DailyDateProvider(ApiConstants.dailyDuaToken);

  @override
  Future<void> onInit() async {
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
