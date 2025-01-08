import 'dart:developer';
import 'package:allwork/modals/api_response_handler.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class SearchProvider {
  final Dio _dio;

  SearchProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${ApiConstants.token}',
            },
          ),
        );

  Future<ApiResponseHandler> fetchSearchResults({
    required String keywords,
    required int page,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.searchEndpoint,
        queryParameters: {
          "keywords": keywords,
          "page": page,
        },
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        return ApiResponseHandler.fromJson(response.data);
      } else {
        log('Failed to fetch search data', error: response.data);
        throw Exception('Failed to fetch search data');
      }
    } catch (e) {
      log('Error fetching search data: $e');
      throw Exception('Error fetching search data: $e');
    }
  }
}
