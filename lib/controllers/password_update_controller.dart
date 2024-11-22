import 'package:allwork/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:allwork/providers/password_update_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordUpdateController extends GetxController {
  final isLoading = false.obs;
  final passwordUpdateMessage = ''.obs;
  final PasswordUpdateProvider _passwordUpdateProvider =
      PasswordUpdateProvider(ApiConstants.token);

  Future<void> updatePassword(                                                  
      String oldPassword, String newPassword, String confirmPassword) async {
    try {
      isLoading(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId') ?? '';

      if (userId.isEmpty) {
        throw Exception("User ID not available. Please log in again.");
      }

      String message = await _passwordUpdateProvider.updatePassword(
          userId, oldPassword, newPassword, confirmPassword);
      passwordUpdateMessage.value = message;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating password: $e');
      }
    } finally {
      isLoading(false);
    }
  }
}
