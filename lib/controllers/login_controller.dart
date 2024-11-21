import 'package:allwork/modals/login_response.dart';
import 'package:allwork/providers/login_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final loginResponse = Rx<LoginResponse?>(null);
  final LoginProvider _loginProvider = LoginProvider(ApiConstants.token);

  Future<void> loginUser(String username, String password) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      LoginResponse response =
          await _loginProvider.loginUser(username, password);
      loginResponse.value = response;
    } catch (e) {
      if (kDebugMode) {
        print('Error logging in user: $e');
      }
      if (e is DioException && e.response?.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic> &&
            errorData.containsKey('message')) {
          errorMessage.value = errorData['message'];
        } else {
          errorMessage.value = 'Something went wrong. Please try again.';
        }
      } else {
        errorMessage.value = 'Error logging in user: $e';
      }
    } finally {
      isLoading(false);
    }
  }
}
