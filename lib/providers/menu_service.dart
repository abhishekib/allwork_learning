import 'package:dio/dio.dart';
import '../modals/menu_list.dart';
import '../utils/constants.dart';
import '../utils/constants.dart';

class MenuService {
  final Dio _dio;
  MenuService(String token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(milliseconds: 5000),
            receiveTimeout: const Duration(milliseconds: 3000),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              // Add other headers here if necessary
            },
          ),
        );

  Future<MenuList> fetchMenuList() async {
    try {
      final response = await _dio.get(ApiConstants.menuEndpoint);

      if (response.statusCode == 200) {
        // Parse the response JSON into a MenuList object
        return MenuList.fromJson(response.data);
      } else {
        throw Exception('Failed to load menu list');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors here
      throw Exception('Failed to load menu list: ${e.message}');
    }
  }
}
