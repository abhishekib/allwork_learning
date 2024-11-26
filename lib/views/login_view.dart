import 'package:allwork/controllers/login_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:allwork/widgets/labeled_input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBlue,
          title: Text(
            "Login",
            style: AppTextStyles.whiteBoldTitleText,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledInputField(
                  label: "Username or Email",
                  hintText: "Enter your username or email",
                  controller: usernameController,
                  isNotEditable: false,
                ),
                const SizedBox(height: 20),
                LabeledInputField(
                  label: "Password",
                  hintText: "Enter your password",
                  controller: passwordController,
                  isPassword: true,
                  isNotEditable: false,
                ),
                const SizedBox(height: 30),
                Center(
                  child: Obx(() {
                    if (loginController.isLoading.value) {
                      return const CircularProgressIndicator();
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          _onLogin();
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
                          "Login",
                          style: TextStyle(
                            color: AppColors.backgroundBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showErrorAlert("Error", "Username and password are required");
      return;
    }

    loginController.loginUser(username, password).then((_) {
      if (loginController.errorMessage.isNotEmpty) {
        _showErrorAlert("Error", loginController.errorMessage.value);
      } else {
        // Show success dialog when login is successful
        _showSuccessDialog();
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
        Get.back(); // Close the dialog
      },
    );
  }

  void _showSuccessDialog() {
    Get.defaultDialog(
      title: "Logged In Successfully",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: const Text(
        "Welcome to the main menu",
        style: TextStyle(fontSize: 16),
      ),
      textConfirm: "Go to Main Menu",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.backgroundBlue,
      onConfirm: () {
        loginController.isLoggedIn.value = true;
        Get.back();
        Get.back();
        Get.back();
        // Get.off(() => MainMenuView());
      },
    );
  }
}
