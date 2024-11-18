import 'dart:developer';

import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:allwork/modals/category_response.dart';

class CategoryProvider {
  final String token;
  final Dio _dio = Dio();
  final String baseurl = ApiConstants.baseUrl;

  CategoryProvider(this.token);

  Future<CategoryResponse> fetchCategoryData(String endpoint,
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

      log("API Response: ${response.data}");

      if (response.statusCode == 200) {
        return CategoryResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to fetch data from $endpoint');
      }
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }
}
