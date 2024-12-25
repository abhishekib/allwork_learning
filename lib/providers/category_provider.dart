import 'dart:developer';

import 'package:allwork/modals/category.dart';
import 'package:allwork/services/db_services.dart';
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

      if (response.statusCode == 200) {
        CategoryResponse categoryResponse =
            CategoryResponse.fromJson(response.data['data']);
            

        final Map<String, dynamic> test = response.data['data'];
        test.entries.forEach((item) {
          log("1st CAT: ${item.key}");
          log("Raw type: ${item.value.runtimeType}");
          if (item.value is List<dynamic>) {
            //other ziyarats
            log("Go to lyrics page for ${item.key}");
            // final List<Category> list = item.value;
            // log("CDATA -----------: ${list[0].id}"); //441
          } else {
            //ziyarat 14 masoomeen
            //final Map<String, List<dynamic>> secondData = item.value;
            log("Create another screen for ${item.key} and ${item.value.runtimeType}");
            //log("RAW RES: ${item.value}");
            final Map<String, dynamic> secondLayer = item.value;
            log("So i will create a listing for ${secondLayer.keys.toList()[0]} and rawtype of value: ${secondLayer.values.toList()[0].runtimeType}");
            final List<dynamic> cdataList = secondLayer.values.toList()[0];
            log("before CDATA ------> ${cdataList[0].runtimeType}");
            final Map<String, Category> sometext = cdataList[0];
            log("seee---------> ${sometext}");
            log("RAW cdatalist : ${secondLayer.values.toList()[0].runtimeType}");
            //log("Next will be CDATA: ${secondLayer.values.toList()[0][0].id}"); //451
          }
        });

        log("data getting written with endpoint $endpoint");
        DbServices.instance.writeCategoryResponse(endpoint, categoryResponse);

        return categoryResponse;
      } else {
        throw Exception('Failed to fetch data from $endpoint');
      }
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }
}
