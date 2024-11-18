import 'package:allwork/modals/user_info.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class UserInfoProvider {
  final Dio _dio;

  UserInfoProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.myDuaBaseUrl,
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );

  Future<UserInfo> fetchUserInfo(String userId) async {
    try {
      final response = await _dio.get(ApiConstants.userinfo, queryParameters: {
        'userid': userId,
      });

      if (response.statusCode == 200) {
        return UserInfo.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user info');
      }
    } catch (e) {
      throw Exception('Error fetching user info: $e');
    }
  }
}
