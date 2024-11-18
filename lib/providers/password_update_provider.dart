import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class PasswordUpdateProvider {
  final Dio _dio;

  PasswordUpdateProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.myDuaBaseUrl,
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );

  Future<String> updatePassword(String userId, String oldPassword,
      String newPassword, String confirmPassword) async {
    try {
      final response = await _dio.post(
        'changepassword',
        queryParameters: {
          'userid': userId,
          'oldpassword': oldPassword,
          'newpassword': newPassword,
          'cnewpassword': confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Password updated successfully';
      } else {
        throw Exception('Failed to update password');
      }
    } catch (e) {
      throw Exception('Error updating password: $e');
    }
  }
}
