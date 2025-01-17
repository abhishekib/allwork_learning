import 'dart:developer';

import 'package:allwork/modals/api_response_handler.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class CategoryProvider {
  final String token;
  final Dio _dio = Dio();
  final String baseurl = ApiConstants.baseUrl;

  CategoryProvider(this.token);

/*
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

      // log("API Response: ${response.data}");

      if (response.statusCode == 200) {
        CategoryResponse categoryResponse =
            CategoryResponse.fromJson(response.data['data']);

        log("data getting written with endpoint $endpoint");
        DbServices.instance.writeCategoryResponse(endpoint, categoryResponse);

        var responseFromDb = DbServices.instance.getCategoryResponse(endpoint)!;
        log("Response from database $responseFromDb");
        return responseFromDb;
        //return categoryResponse;
      } else {
        throw Exception('Failed to fetch data from $endpoint');
      }
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }

  Future<CategoryResponse2> fetchCategoryData2(String endpoint) async {
    try {
      // Construct the URL with query parameters
      String url = '$baseurl$endpoint';

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
        CategoryResponse2 categoryResponse2 =
            CategoryResponse2.fromJson(response.data['data']);

        

        log(categoryResponse2.toString());

        DbServices.instance.writeCategoryResponse2(endpoint, categoryResponse2);

        return categoryResponse2;
        //return DbServices.instance.getCategoryResponse2();
      } else {
        throw Exception('Failed to fetch data from $endpoint');
      }
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }
*/

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

      // log("API Response: ${response.data}");

      if (response.statusCode == 200) {
        ApiResponseHandler apiResponseHandler =
            ApiResponseHandler.fromJson(response.data);

        DbServices.instance
            .writeApiResponseHandler(endpoint, apiResponseHandler); 


        log("data getting written with endpoint $endpoint");
        //log(apiResponseHandler.toString());

        // ApiResponseHandler? apiResponseHandler2 =
        //     DbServices.instance.getApiResponseHandler(endpoint);

        //log("Data reverted from ${apiResponseHandler2.toString()}");

        //DbServices.instance.writeCategoryResponse(endpoint, categoryResponse);

        //var responseFromDb = DbServices.instance.getCategoryResponse(endpoint)!;
        //log("Response from database $responseFromDb");
        return apiResponseHandler;
        //return categoryResponse;
      } else {
        throw Exception('Failed to fetch data from $endpoint');
      }
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }
}
