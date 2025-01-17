import 'dart:developer';

import 'package:allwork/modals/google_sign_in_model.dart';
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
  final GoogleSignInModel _model = GoogleSignInModel();

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
        // Display a friendly message for unsuccessful login attempts
        errorMessage.value = 'Invalid username or password. Please try again.';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging in user: $e');
      }
      if (e is DioException && e.response?.data != null) {
        final errorData = e.response!.data;

        // Handle type mismatch issues
        if (errorData is String) {
          errorMessage.value = 'Unexpected error: Invalid response format.';
        } else if (errorData is Map<String, dynamic> &&
            errorData.containsKey('message')) {
          errorMessage.value = errorData['message'];
        } else {
          errorMessage.value = 'Something went wrong. Please try again.';
        }
      } else if (e is TypeError) {
        errorMessage.value =
            'An internal error occurred. Please contact support if the issue persists.';
      } else {
        if (kDebugMode) {
          print("HERE -->" 'Error logging in user: $e');
        }
        //errorMessage.value = 'Error logging in user: $e';
        errorMessage.value =
            "Invalid username or password. \nPlease try again.";
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId') ?? '';

      if (userId.isEmpty) {
        throw Exception("User ID not available. Please log in again.");
      }

      String message = await _loginProvider.deleteUserAccount(userId);
      errorMessage.value = message;
    } catch (e) {
      if (kDebugMode) {
        print('Error Deleting User Account: $e');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> _saveUserLoginState(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('userId', response.message!.data.id);
    prefs.setString('userData', response.message!.data.displayName);
    prefs.setString('userEmail', response.message!.data.userEmail);
  }

  Future<void> _loadUserLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn.value) {
      final String? userId = prefs.getString('userId');
      final String? displayName = prefs.getString('userData');
      final String? userEmail = prefs.getString('userEmail');

      if (userId != null && displayName != null && userEmail != null) {
        loginResponse.value = LoginResponse(
          message: Message(
            data: Data(
              id: userId,
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
            id: int.parse(userId),
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

  Future<void> loginWithGoogle() async {
    try {
      isLoading(true);
      errorMessage.value = '';

      final userData = await _model.signInWithGoogle();

      if (userData != null) {
        final idToken = userData['idToken'];
        final response = await _loginProvider.loginWithGoogle(idToken);

        if (response.status == 'success') {
          loginResponse.value = response;
          isLoggedIn.value = true;

          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          prefs.setString('userEmail', userData['email']);
          prefs.setString('displayName', userData['displayName']);
        } else {
          errorMessage.value = 'Failed to authenticate with backend.';
        }
        isLoggedIn.value = true;
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('userId', loginResponse.value!.user!.userId);
      } else {
        errorMessage.value = 'Google login failed. Please try again.';
      }
    } catch (e) {
      // log('LoginResponse or User object is null: ${loginResponse.value}');
      errorMessage.value = 'An error occurred while logging in with Google: $e';
      log(errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await _model.signOutFromGoogle();
      if (kDebugMode) {
        log('Google Sign-Out successful');
      }
    } catch (e) {
      if (kDebugMode) {
        log('Error signing out from Google: $e');
      }
    }

    await prefs.clear();
    isLoggedIn.value = false;
  }
}
