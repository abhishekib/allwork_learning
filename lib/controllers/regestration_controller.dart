import 'package:allwork/modals/registration_response.dart';
import 'package:allwork/providers/regestration_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  final isLoading = false.obs;
  final registrationResponse = Rx<RegistrationResponse?>(null);
  final RegistrationProvider _registrationProvider = RegistrationProvider();

  Future<void> registerUser(String username, String password, String email,
      String firstName, String lastName) async {
    try {
      isLoading(true);
      RegistrationResponse response = await _registrationProvider.registerUser(
          username, password, email, firstName, lastName);
      registrationResponse.value = response;
    } catch (e) {
      if (kDebugMode) {
        print('Error registering user: $e');
      }
    } finally {
      isLoading(false);
    }
  }
}
