import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:allwork/modals/favourite_model.dart';
import 'package:allwork/utils/constants.dart';

class FavouriteProvider {
  final Dio _dio;

  FavouriteProvider(String token)
      : _dio = Dio(
          BaseOptions(baseUrl: ApiConstants.baseUrl, headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }),
        );

  // Fetch favourite list based on userId and token
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
        final List<FavouriteModel> favouriteItems =
            (response.data['data'] as List)
                .map((item) => FavouriteModel.fromJson(item))
                .toList();
        return favouriteItems;
      } else {
        throw Exception('Failed to fetch favourite list');
      }
    } catch (e) {
      throw Exception('Error fetching favourite list: $e');
    }
  }
}
