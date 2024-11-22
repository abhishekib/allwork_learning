import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class PasswordUpdateProvider {
  final Dio _dio;
  final String token;

  PasswordUpdateProvider(this.token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );

  Future<String> updatePassword(String userId, String oldPassword,
      String newPassword, String confirmPassword) async {
    try {
      final response = await _dio.post(
        ApiConstants.updatePassword,
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
