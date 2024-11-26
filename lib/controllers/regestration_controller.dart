import 'package:allwork/modals/registration_response.dart';
import 'package:allwork/providers/regestration_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  final onComplete = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final registrationResponse = Rx<RegistrationResponse?>(null);
  final RegistrationProvider _registrationProvider =
      RegistrationProvider(ApiConstants.token);

  Future<void> registerUser(String username, String password, String email,
      String firstName, String lastName) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      RegistrationResponse response = await _registrationProvider.registerUser(
          username, password, email, firstName, lastName);

      // Check if the response type is 'error' and update error message
      if (response.type.toLowerCase() == 'error') {
        errorMessage.value = response.message;
      } else {
        registrationResponse.value = response;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error registering user: $e');
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
        errorMessage.value = 'Error registering user: $e';
      }
    } finally {
      isLoading(false);
    }
  }
}
