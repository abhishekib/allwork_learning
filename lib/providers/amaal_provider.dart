import 'dart:developer';

import 'package:allwork/modals/amaal_model.dart';
import 'package:dio/dio.dart';
import 'package:allwork/utils/constants.dart';

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

  Future<AmaalModel> fetchAmaalData() async {
    try {
      final response = await _dio.post(ApiConstants.amaalEndpoint);
      log("amal------->${response.data.toString()}");
      if (response.statusCode == 200) {
        return AmaalModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch Amaal data');
      }
    } catch (e) {
      throw Exception('Error fetching Amaal data: $e');
    }
  }
}
