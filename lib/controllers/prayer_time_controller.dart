import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:allwork/providers/prayer_time_provider.dart';
import 'package:allwork/modals/prayer_time_model.dart';
import '../utils/constants.dart';

class PrayerTimeController extends GetxController {
  final isLoading = false.obs;
  final prayerTimeModel = Rx<PrayerTimeModel?>(null);

  late final PrayerTimeProvider _prayerTimeProvider;

  @override
  void onInit() {
    super.onInit();
    // Initialize the provider with the token
    _prayerTimeProvider = PrayerTimeProvider(ApiConstants.dailyDuaToken);
    fetchPrayerTimes(52.569500, -0.240530);
  }

  Future<void> fetchPrayerTimes(double latitude, double longitude) async {
    try {
      isLoading(true);
      final response = await _prayerTimeProvider.fetchPrayerTimes(
        latitude: latitude,
        longitude: longitude,
      );
      prayerTimeModel.value = response;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching prayer times: $e');
      }
    } finally {
      isLoading(false);
    }
  }
}
