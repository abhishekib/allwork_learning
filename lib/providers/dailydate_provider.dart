import 'dart:convert';
import 'dart:developer';
import 'package:allwork/services/db_services.dart';
import 'package:dio/dio.dart';
import 'package:allwork/modals/daily_date.dart';
import '../utils/constants.dart';

class DailyDateProvider {
  final Dio _dio;

  DailyDateProvider(String token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.myDuaBaseUrl, // Base URL from ApiConstants
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );

  Future<DailyDate> fetchDailyDate() async {
    final body = json.encode({
      'tz': 'Asia/Kolkata',
      'dd': -1,
    });

    try {
      // API endpoint URL for fetching daily date
      final response = await _dio.post(
        ApiConstants.dailyDateEndpoint,
        data: body,
      );
      log("message----------->$response");

      if (response.statusCode == 200) {
        final data = response.data;
        log("Daily Date ---->$data");

        // Parse the JSON response into a DailyDate object
        DailyDate dailyDate = DailyDate.fromJson(data);

        DbServices.instance.writeDailyDate(dailyDate);

        return dailyDate;
      } else {
        throw Exception('Failed to fetch daily date');
      }
    } catch (e) {
      throw Exception('Error fetching daily date: $e');
    }
  }
}
