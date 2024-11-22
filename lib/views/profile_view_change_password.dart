import 'package:allwork/controllers/password_update_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/labeled_input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final PasswordUpdateController passwordUpdateController =
      Get.put(PasswordUpdateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundBlue,
        centerTitle: true,
        title: Text("Change Password", style: AppTextStyles.whiteBoldText),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        return passwordUpdateController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabeledInputField(
                        label: "Current Password",
                        hintText: "Enter Current Password",
                        controller: currentPasswordController,
                        isPassword: true,
                        isNotEditable: false,
                      ),
                      const SizedBox(height: 10),
                      LabeledInputField(
                        label: "New Password",
                        hintText: "Enter New Password",
                        controller: newPasswordController,
                        isPassword: true,
                        isNotEditable: false,
                      ),
                      const Text(
                        "Use a strong password for your account",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      LabeledInputField(
                        label: "Confirm New Password",
                        hintText: "Confirm New Password",
                        controller: confirmPasswordController,
                        isPassword: true,
                        isNotEditable: false,
                      ),
                      const Text(
                        "Use a strong password for your account",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _onChangePassword();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: AppColors.backgroundBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  void _onChangePassword() {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorAlert("Error", "All fields are required");
      return;
    }

    if (newPassword != confirmPassword) {
      _showErrorAlert(
          "Error", "New password and confirm password do not match");
      return;
    }

    passwordUpdateController
        .updatePassword(currentPassword, newPassword, confirmPassword)
        .then((_) {
      if (passwordUpdateController.passwordUpdateMessage.value.isNotEmpty) {
        _showSuccessAlert(
            "Success", passwordUpdateController.passwordUpdateMessage.value);
      }
    });
  }

  void _showErrorAlert(String title, String message) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.backgroundBlue,
      onConfirm: () {
        Get.back();
      },
    );
  }

  void _showSuccessAlert(String title, String message) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.backgroundBlue,
      onConfirm: () {
        Get.back();
        Get.back();
      },
    );
  }
}
