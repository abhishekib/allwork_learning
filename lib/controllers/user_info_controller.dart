import 'package:allwork/modals/user_info.dart';
import 'package:allwork/providers/user_info_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final userInfo = Rx<UserInfo?>(null);

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final genderController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final UserInfoProvider _userInfoProvider =
      UserInfoProvider(ApiConstants.token);

  Future<void> fetchUserInfo() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId') ?? '';

      UserInfo response = await _userInfoProvider.fetchUserInfo(userId);
      userInfo.value = response;

      // Set the controllers with fetched values
      firstNameController.text = response.firstName;
      lastNameController.text = response.lastName;
      genderController.text = response.gender;
      phoneController.text = response.phone;
      emailController.text = response.email ?? '';
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user info: $e');
      }
      errorMessage.value = 'Failed to load user info';
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateUserInfo() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId') ?? '';

      await _userInfoProvider.updateUserInfo(
        userId: userId,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        gender: genderController.text,
        phone: phoneController.text,
      );

      // After updating, reset the editing mode
      userInfo.value = UserInfo(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        gender: genderController.text,
        phone: phoneController.text,
        email: emailController.text,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user info: $e');
      }
      errorMessage.value = 'Failed to update user info';
    } finally {
      isLoading(false);
    }
  }

  void resetFields() {
    if (userInfo.value != null) {
      firstNameController.text = userInfo.value!.firstName;
      lastNameController.text = userInfo.value!.lastName;
      genderController.text = userInfo.value!.gender;
      phoneController.text = userInfo.value!.phone;
    }
  }
}
