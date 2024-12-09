import 'dart:developer';
import 'package:allwork/modals/favourite_model.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class FavouriteProvider {
  final Dio _dio;

  FavouriteProvider(String token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );

  Future<List<FavouriteModel>> fetchFavouriteList(
      String endpoint, String userId) async {
    try {
      final response = await _dio.post(
        endpoint,
        queryParameters: {
          'userid': userId,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'] ?? [];
        return data.map((item) => FavouriteModel.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to fetch favourite list: ${response.statusCode}');
      }
    } catch (e) {
      log("Error fetching favourite list: $e");
      throw Exception('Error fetching favourite list: $e');
    }
  }

  Future addToFavourite(String endpoint, String userId, int itemId) async {
    try {
      log("Item Id from provider: $itemId");

      final response = await _dio.post(
        endpoint,
        queryParameters: {
          'userid': userId,
          'postid': itemId,
        },
      );

      if (response.statusCode == 200) {
        log("Item added to favourites successfully");
        return true;
      } else {
        log('Failed to add to favourites: ${response.statusCode}');
        throw Exception('Failed to add to favourites: ${response.statusCode}');
      }
    } catch (e) {
      log("Error adding to favourite: $e");
      throw Exception('Error adding to favourite: $e');
    }
  }
}
