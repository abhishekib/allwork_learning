import 'dart:developer';

import 'package:allwork/entities/menu_detail_entity.dart';
import 'package:allwork/modals/api_response_handler.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/category_response.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class DeepLinkingProvider {
  final Dio _dio;
  final String token;
  final String baseurl = ApiConstants.baseUrl;
  final String endpoint = 'deeplink';
  DeepLinkingProvider(this.token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );

  Future<ApiResponseHandler> getDeepLinkingResponse(String deepLink) async {
    try {
      String url = '$baseurl$endpoint';

      final response =
          await _dio.post(url, queryParameters: {'permalink': deepLink});

      if (response.statusCode == 200) {
        log(response.data.toString());
        ApiResponseHandler apiResponseHandler =
            ApiResponseHandler.fromJson(response.data);

        Category category = Category.fromJson(apiResponseHandler.data['data']);

        DbServices.instance
            .writeDeepLink(deepLink, category);
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
