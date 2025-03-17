import 'dart:developer';
import 'dart:io';

import 'package:allwork/modals/apple_signin_model.dart';
import 'package:allwork/modals/google_sign_in_model.dart';
import 'package:allwork/modals/login_response.dart';
import 'package:allwork/providers/login_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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
  final AppleSignInModel _appleSignInModel = AppleSignInModel();
  late String fcmToken;

  @override
  Future<void> onInit() async {
    super.onInit();
    _loadUserLoginState();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fcmToken = prefs.getString("FCM_TOKEN")??'';
  }

  Future<void> loginUser(String username, String password) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      LoginResponse response =
          await _loginProvider.loginUser(username, password, fcmToken);

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
    isLoading(true);
    errorMessage.value = '';
    try {
      final result = await _model.signInWithGoogle();
      
      if (result != null) {
        final firebase_auth.UserCredential? userCredential =
            result['userCredential'];
        // final String? idToken = result['idToken'];
        final firebase_auth.User? user = userCredential?.user;

        if (/* idToken != null && */ user != null) {
          // log('idToken--------->$idToken');
          final names = user.displayName?.split(' ') ?? [''];
          final firstName = names.isNotEmpty ? names.first : '';
          final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

          final response = await _loginProvider.socialLogin(
            'google',
            firstName,
            lastName,
            user.email,
            fcmToken
          );

          isLoggedIn.value = true;
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          prefs.setString('userId', response.user!.userId);
        }
      } else {
        errorMessage.value = 'Google login failed. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred while logging in with Google: $e';
      log(errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loginWithApple() async {
    if (!Platform.isIOS) {
      Get.snackbar("Error", "Apple Sign-In is only supported on iOS.");
      return;
    }

    isLoading(true);
    errorMessage.value = '';

    try {
      final result = await _appleSignInModel.signInWithApple();
      if (result != null) {
        final firebase_auth.UserCredential? userCredential =
            result['userCredential'];
        final firebase_auth.User? user = userCredential?.user;

        if (userCredential != null && user != null) {
          final names = user.displayName?.split(' ') ?? [''];
          final firstName = names.isNotEmpty ? names.first : '';
          final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

          final response = await _loginProvider.socialLogin(
            'apple',
            firstName,
            lastName,
            user.email,
            fcmToken
          );
          isLoggedIn.value = true;

          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          prefs.setString('userId', response.user!.userId);
        }
      } else {
        errorMessage.value = 'Apple login failed. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred while logging in with Apple: $e';
    } finally {
      isLoading(false);
    }
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await _model.signOutFromGoogle();
      await _appleSignInModel.signOutFromApple();
      if (kDebugMode) {
        log('Google & Apple Sign-Out successful');
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
