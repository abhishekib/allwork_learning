import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:allwork/utils/constants.dart';
import 'package:allwork/modals/prayer_time_model.dart';

class PrayerTimeProvider {
  final Dio _dio;

  PrayerTimeProvider(String token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.myDuaBaseUrl,
            headers: {
              'Authorization': 'Bearer $token', // Added authorization token
              'Content-Type': 'application/json',
            },
          ),
        );

  Future<PrayerTimeModel> fetchPrayerTimes({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Send the POST request with lat and long as body parameters
      final response = await _dio.post(
        ApiConstants.prayertime,
        data: {
          'lat': latitude,
          'long': longitude,
        },
      );

      log("API Response: ${response.data}");

      if (response.statusCode == 200) {
        return PrayerTimeModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch prayer times');
      }
    } catch (e) {
      log("Error fetching prayer times: $e");
      throw Exception('Error fetching prayer times: $e');
    }
  }
}
