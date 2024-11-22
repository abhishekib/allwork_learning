import 'package:allwork/modals/user_info.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class UserInfoProvider {
  final Dio _dio;
  final String token;

  UserInfoProvider(this.token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );

  // Fetch user information from the API
  Future<UserInfo> fetchUserInfo(String userId) async {
    try {
      final response = await _dio.post(
        ApiConstants.userinfo,
        queryParameters: {
          'userid': userId,
        },
      );

      if (response.statusCode == 200) {
        return UserInfo.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user info');
      }
    } catch (e) {
      throw Exception('Error fetching user info: $e');
    }
  }

  // Update user information through the API
  Future<String> updateUserInfo({
    required String userId,
    required String firstName,
    required String lastName,
    required String gender,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.updateUserInfo,
        queryParameters: {
          'userid': userId,
          'firstname': firstName,
          'lastname': lastName,
          'gender': gender,
          'phone': phone,
        },
      );

      if (response.statusCode == 200 && response.data['type'] == 'success') {
        return response.data['msg'] ?? 'Profile updated successfully';
      } else {
        throw Exception('Failed to update user info');
      }
    } catch (e) {
      throw Exception('Error updating user info: $e');
    }
  }
}
