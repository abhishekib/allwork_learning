import 'dart:developer';
import 'dart:isolate';

import 'package:allwork/modals/api_response_handler.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class CategoryProvider {
  final String token;
  final Dio _dio = Dio();
  final String baseurl = ApiConstants.baseUrl;

  CategoryProvider(this.token);

  Future<ApiResponseHandler> fetchApiResponse(String endpoint,
      [String? day]) async {
    try {
      // Construct the URL with query parameters
      String url = '$baseurl$endpoint';
      if (day != null) {
        url = '$url&day=$day';
      }

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

//==========================================
//write data in DB in a separate isolate
        final receivePort = ReceivePort();
        await Isolate.spawn((SendPort sendPort) async {
          DbServices.instance
              .writeApiResponseHandler(endpoint, apiResponseHandler);
              sendPort.send('Data saved in DB');
        }, receivePort.sendPort);

        receivePort.listen((message) {
          log(message);
        });
//==========================================

        // ApiResponseHandler? apiResponseHandlerFromDB =
        //     DbServices.instance.getApiResponseHandler(endpoint);
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
