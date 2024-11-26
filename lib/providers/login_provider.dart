import 'package:allwork/utils/constants.dart';
import 'package:allwork/modals/login_response.dart';
import 'package:dio/dio.dart';

class LoginProvider {
  final Dio _dio;
  final String token;

  LoginProvider(this.token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );

  Future<LoginResponse> loginUser(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        queryParameters: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to login user');
      }
    } catch (e) {
      throw Exception('Error logging in user: $e');
    }
  }

  Future<String> deleteUserAccount(String userId) async {
    try {
      final response = await _dio.delete(
        ApiConstants.deleteUser,
        queryParameters: {'userid': userId},
      );

      if (response.statusCode == 200) {
        return response.data['msg'] ?? 'Account Deleted Successfully';
      } else {
        throw Exception('Failed to update password');
      }
    } catch (e) {
      throw Exception('Error updating password: $e');
    }
  }
}
