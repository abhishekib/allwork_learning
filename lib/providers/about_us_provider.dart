import 'dart:developer';
import 'dart:isolate';

import 'package:allwork/modals/about_us_response.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class AboutUsProvider {
  final Dio _dio;
  final String token;

  AboutUsProvider(this.token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );

  Future<AboutUsResponse> getAboutUs() async {
    try {
      final response = await _dio.get(
        ApiConstants.aboutusEndpoint,
      );

      if (response.statusCode == 200) {
        AboutUsResponse responseModel = AboutUsResponse.fromJson(response.data);

        final receivePort = ReceivePort();
        await Isolate.spawn((SendPort sendPort) {
          DbServices.instance.writeAboutUs(responseModel);
          sendPort.send('Data saved in DB of About Us');
          Isolate.exit();
        }, receivePort.sendPort);

        receivePort.listen((message) {
          log(message);
        });
        return responseModel;
      } else {
        throw Exception('Failed to get Our About Us Data');
      }
    } catch (e) {
      throw Exception('Error Loading About Us Data');
    }
  }
}
