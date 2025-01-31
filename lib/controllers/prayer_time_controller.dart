import 'dart:developer';

import 'package:allwork/services/db_services.dart';
import 'package:allwork/services/location_services.dart';
import 'package:allwork/utils/menu_helpers/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:allwork/providers/prayer_time_provider.dart';
import 'package:allwork/modals/prayer_time_model.dart';
import '../utils/constants.dart';

class PrayerTimeController extends GetxController {
  var isLoading = true.obs;
  var prayerTimeModel = Rx<PrayerTimeModel?>(null);

  late final PrayerTimeProvider _prayerTimeProvider;

  @override
  Future<void> onInit() async {
    super.onInit();
    bool hasInternet = await Helpers.hasActiveInternetConnection();
    if (hasInternet) {
      _prayerTimeProvider = PrayerTimeProvider(ApiConstants.dailyDuaToken);

      final position = await LocationService.getUserLocation();
      final lat = position?.latitude ?? '';
      final long = position?.longitude ?? '';

      fetchPrayerTimesFromAPI(lat, long);
      log('Internet connection is active');
    } else {
      fetchPrayerTimesFromDB();
      log('No internet connection');
    }
  }

  Future<void> fetchPrayerTimesFromAPI(latitude, longitude) async {
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

  Future<void> fetchPrayerTimesFromDB() async {
    try {
      isLoading(true);
      prayerTimeModel.value = DbServices.instance.getPrayerTimeModel();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching prayer times: $e');
      }
    } finally {
      isLoading(false);
    }
  }
}
