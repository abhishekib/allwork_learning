import 'package:allwork/modals/daily_date.dart';
import 'package:allwork/providers/dailydate_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

class DailyDateController extends GetxController {
  final isLoading = false.obs;
  final dailyDate = Rx<DailyDate?>(null);
  final DailyDateProvider _dailyDateProvider =
      DailyDateProvider(ApiConstants.dailyDuaToken);

  @override
  void onInit() {
    super.onInit();
    fetchDailyDate();
  }

  Future<void> fetchDailyDate() async {
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
}
