import 'dart:developer';

import 'package:allwork/modals/registration_response.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class RegistrationProvider {
  final Dio _dio;
  final String token;
  RegistrationProvider(this.token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );

  Future<RegistrationResponse> registerUser(String username, String password,
      String email, String firstName, String lastName) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        queryParameters: {
          'username': username,
          'password': password,
          'email': email,
          'firstname': firstName,
          'lastname': lastName,
        },
      );

      if (response.statusCode == 200) {
        log("Register Provider--->$response");
        return RegistrationResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }
}
