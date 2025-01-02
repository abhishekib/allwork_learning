/*
import 'dart:developer';
import 'package:allwork/modals/amaal_model.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class AmaalProvider {
  final Dio _dio;
  final String token;

  AmaalProvider(this.token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );

  Future<AmaalData> fetchAmaalData() async {
    try {
      final response = await _dio.post(ApiConstants.amaalEndpoint);
      log(response.data.toString());
      if (response.statusCode == 200) {
        return AmaalData.fromJson(response.data);
      } else {
        log('Failed to fetch Amaal data', error: response.data);
        throw Exception('Failed to fetch Amaal data');
      }
    } catch (e) {
      log('Error fetching Amaal data: $e');
      throw Exception('Error fetching Amaal data: $e');
    }
  }
}
*/