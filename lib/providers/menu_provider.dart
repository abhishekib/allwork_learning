import 'dart:developer';

import 'package:allwork/services/db_services.dart';
import 'package:dio/dio.dart';
import 'package:allwork/modals/menu_list.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class MenuService {
  final Dio _dio;

  MenuService(String token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            // connectTimeout: const Duration(milliseconds: 15000),
            // receiveTimeout: const Duration(milliseconds: 3000),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );

  Future<MenuList> fetchMenuList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final position = await getUserLocation();

    DateTime now = DateTime.now().toLocal();

    final date = DateFormat('yyyy-MM-dd').format(now);
    final time = DateFormat('HH:mm:ss').format(now);

    final response = await _dio.get(
      ApiConstants.menuEndpoint,
      queryParameters: {
        'lat': position?.latitude ?? '',
        'long': position?.longitude ?? '',
        'date': date,
        'time': time,
        'dd': prefs.getString('hijri_date_adjustment') ?? '0',
      },
    );

    if (response.statusCode == 200) {
      MenuList menuList = MenuList.fromJson(response.data);

      DbServices.instance.writeMenuList(menuList);

      return DbServices.instance.getMenuList();
    } else {
      throw Exception('Failed to fetch menu list');
    }
  }

  Future<Position?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');

      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        log('Location permission denied');
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

    return position;
  }

  Future<MenuList> fetchGujaratiMenuList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final position = await getUserLocation();

    DateTime now = DateTime.now().toLocal();

    final date = DateFormat('yyyy-MM-dd').format(now);
    final time = DateFormat('HH:mm:ss').format(now);

    final response = await _dio.get(
      ApiConstants.gujaratiMenuEndpoint,
      queryParameters: {
        'lat': position?.latitude ?? '',
        'long': position?.longitude ?? '',
        'date': date,
        'time': time,
        'dd': prefs.getString('hijri_date_adjustment') ?? '0',
      },
    );

    if (response.statusCode == 200) {
      MenuList menuList = MenuList.fromJson(response.data);

      DbServices.instance.writeGujratiMenuList(menuList);

      return DbServices.instance.getGujratiMenuList();
    } else {
      throw Exception('Failed to fetch menu list');
    }
  }
}
