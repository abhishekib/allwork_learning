import 'dart:developer';
import 'package:allwork/services/db_services.dart';
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
    required latitude,
    required longitude,
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

      //log("API Response: ${response.data}");

      if (response.statusCode == 200) {
        PrayerTimeModel prayerTimeModel =
            PrayerTimeModel.fromJson(response.data);

        log(prayerTimeModel.toString());

//save the prayer time model in db for offline use
        DbServices.instance
            .writePrayerTimeModel(prayerTimeModel)
            .then((_) => log("prayer times successfully written in db"));

        return prayerTimeModel;
      } else {
        throw Exception('Failed to fetch prayer times');
      }
    } catch (e) {
      log("Error fetching prayer times: $e");
      throw Exception('Error fetching prayer times: $e');
    }
  }
}
