import 'dart:developer';
import 'dart:isolate';

import 'package:allwork/modals/api_response_handler.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:intl/intl.dart';

class CategoryProvider {
  final String token;
  final Dio _dio = Dio();
  final String baseurl = ApiConstants.baseUrl;

  CategoryProvider(this.token);

  Future<ApiResponseHandler> fetchApiResponse(String endpoint,
      [String? day]) async {
    try {
      Future<dynamic> getIpAddress() async {
        try {
          var ipAddress = IpAddress(type: RequestType.json);
          dynamic data = await ipAddress.getIpAddress();
          return data['ip'];
        } on IpAddressException catch (exception) {
          log(exception.message);
        }
      }

      final ipAddress = await getIpAddress();
      // log("IP Address: $ipAddress");

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
        url = '$url&ip=$ipAddress&date=$date&time=$time';
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
        await Isolate.spawn((SendPort sendPort) async {
          DbServices.instance
              .writeApiResponseHandler(endpoint, apiResponseHandler);
              sendPort.send('Data saved in DB');
        }, receivePort.sendPort);

        receivePort.listen((message) {
          log(message);
        });
        
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
