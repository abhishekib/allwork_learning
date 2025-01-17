import 'dart:convert';
import 'dart:developer';
// import 'dart:developer';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/helpers.dart';
import 'package:dio/dio.dart';
import 'package:allwork/modals/daily_date.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      log(data['ip'].toString());
      return data['ip'];
    } on IpAddressException catch (exception) {
      /// Handle the exception.
      log(exception.message);
    }
  }

  Future<Position?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (kDebugMode) {
        print('Location services are disabled.');
      }
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        if (kDebugMode) {
          print('Location permission denied');
        }
        return null;
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

    log("Position lat ${position.latitude}");
    log("Position long ${position.longitude}");

  return position;
  }


  Future<DailyDate> fetchDailyDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final ipAddress = await getIpAddress();
    log("IP Address: $ipAddress");

    final position = await getUserLocation();
    

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
          'lat': position?.latitude??'',
          'long':  position?.longitude??'',
          'ip': ipAddress,
          'date': date,
          'time': time,
          'dd': prefs.getString('hijri_date_adjustment') ?? '0',
        },
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
