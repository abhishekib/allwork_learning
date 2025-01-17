import 'dart:convert';
import 'dart:developer';
// import 'dart:developer';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/helpers.dart';
import 'package:dio/dio.dart';
import 'package:allwork/modals/daily_date.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:intl/intl.dart';
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

  Future<dynamic> getIpAddress() async {
    try {
      /// Initialize Ip Address
      var ipAddress = IpAddress(type: RequestType.json);

      /// Get the IpAddress based on requestType.
      dynamic data = await ipAddress.getIpAddress();
      //log(data.toString());
      return data['ip'];
    } on IpAddressException catch (exception) {
      /// Handle the exception.
      log(exception.message);
    }
  }

  Future<DailyDate> fetchDailyDate() async {
    final userTimeZone = await getUserTimeZone();

    final body = json.encode({
      'tz': userTimeZone,
      'dd': -1,
    });

    final ipAddress = await getIpAddress();
    log("IP Address: $ipAddress");

    DateTime now = DateTime.now().toLocal();

    final date = DateFormat('yyyy-MM-dd').format(now);
    final time = DateFormat('HH:mm:ss').format(now);

    log("Date going $date");
    log("Time going $time");

    try {
      // API endpoint URL for fetching daily date
      final response = await _dio.post(
        ApiConstants.dailyDateEndpoint,
        queryParameters: {
          'ip': ipAddress,
          'date': date,
          'time': time,
        },
        data: body,
      );

      //log("message----------->$response");

      if (response.statusCode == 200) {
        final data = response.data;
        // log("response from daily date: $data");
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
