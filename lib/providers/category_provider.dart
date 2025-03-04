import 'dart:developer';
import 'dart:isolate';

import 'package:allwork/modals/api_response_handler.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/services/location_services.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider {
  final String token;
  final Dio _dio = Dio();
  final String baseurl = ApiConstants.baseUrl;

  CategoryProvider(this.token);

  Future<ApiResponseHandler> fetchApiResponse(String endpoint, bool save,
      [String? day]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final setHijiriDate = prefs.getString('hijri_date_adjustment') ?? '0';
      final position = await LocationService.getUserLocation();
      final lat = position?.latitude ?? '';
      final long = position?.longitude ?? '';

      DateTime now = DateTime.now().toLocal();

      final date = DateFormat('yyyy-MM-dd').format(now);
      final time = DateFormat('HH:mm:ss').format(now);

      // log("Date going $date");
      // log("Time going $time");

      // Construct the URL with query parameters
      String url = '$baseurl$endpoint';
      if (day != null) {
        url = '$url&day=$day';
      } else if (endpoint == 'amaal-namaz?lang=english' ||
          endpoint == 'amaal-namaz?lang=gujarati') {
        url =
            '$url&dd=$setHijiriDate&date=$date&time=$time&lat=$lat&long=$long';
        // log("hehe boi ----> $url");
      }
      // log(url);

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        ApiResponseHandler apiResponseHandler =
            ApiResponseHandler.fromJson(response.data);

        final receivePort = ReceivePort();
        if (save) {
          log("save is true");
          await Isolate.spawn((SendPort sendPort) {
            DbServices.instance
                .writeApiResponseHandler(endpoint, apiResponseHandler);
            sendPort.send('Data saved in DB with endpoint $endpoint');
            Isolate.exit();
          }, receivePort.sendPort);

          receivePort.listen((message) {
            log(message);
          });
        }
        return apiResponseHandler;
      } else {
        throw Exception('Failed to fetch data from $endpoint');
      }
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }

}
