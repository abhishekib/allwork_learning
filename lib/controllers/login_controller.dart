import 'package:allwork/modals/login_response.dart';
import 'package:allwork/providers/login_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final loginResponse = Rx<LoginResponse?>(null);
  final LoginProvider _loginProvider = LoginProvider(ApiConstants.token);

  @override
  void onInit() {
    super.onInit();
    _loadUserLoginState();
  }

  Future<void> loginUser(String username, String password) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      LoginResponse response =
          await _loginProvider.loginUser(username, password);
      if (response.type == 'success') {
        loginResponse.value = response;
        isLoggedIn.value = true;
        _saveUserLoginState(response);
      } else {
        errorMessage.value = response.type; // Handle specific errors
      }
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

  Future<void> _saveUserLoginState(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('userData', response.message.data.displayName);
    prefs.setString('userEmail', response.message.data.userEmail);
  }

  Future<void> _loadUserLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn.value) {
      // Load saved user data
      final String? displayName = prefs.getString('userData');
      final String? userEmail = prefs.getString('userEmail');
      if (displayName != null && userEmail != null) {
        loginResponse.value = LoginResponse(
          message: Message(
            data: Data(
              id: '',
              userLogin: '',
              userPass: '',
              userNicename: '',
              userEmail: userEmail,
              userUrl: '',
              userRegistered: '',
              userActivationKey: '',
              userStatus: '',
              displayName: displayName,
            ),
            id: 0,
            caps: {},
            capKey: '',
            roles: [],
            allcaps: {},
          ),
          type: 'success',
        );
      }
    }
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    isLoggedIn.value = false;
  }
}
