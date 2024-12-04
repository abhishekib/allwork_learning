import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator package
import 'package:allwork/providers/prayer_time_provider.dart';
import 'package:allwork/modals/prayer_time_model.dart';
import '../utils/constants.dart';

class PrayerTimeController extends GetxController {
  var isLoading = true.obs;
  var prayerTimeModel = Rx<PrayerTimeModel?>(null);

  late final PrayerTimeProvider _prayerTimeProvider;

  @override
  void onInit() {
    super.onInit();
    _prayerTimeProvider = PrayerTimeProvider(ApiConstants.dailyDuaToken);
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (kDebugMode) {
        print('Location services are disabled.');
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        if (kDebugMode) {
          print('Location permission denied');
        }
        return;
      }
    }

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      timeLimit: Duration(seconds: 30),
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    fetchPrayerTimes(position.latitude, position.longitude);
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
