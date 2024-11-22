import 'package:allwork/controllers/regestration_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:allwork/widgets/labeled_input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RegistrationController registrationController =
      Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBlue,
          title: Text(
            "Create Account",
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
                  label: "Enter Unique Username",
                  hintText: "Your unique username",
                  controller: userNameController,
                  isNotEditable: false,
                ),
                LabeledInputField(
                  label: "What's your first name?",
                  hintText: "Your First Name",
                  controller: firstNameController,
                  isNotEditable: false,
                ),
                LabeledInputField(
                  label: "What's your last name?",
                  hintText: "Your Last Name",
                  controller: lastNameController,
                  isNotEditable: false,
                ),
                LabeledInputField(
                  label: "What's your email?",
                  hintText: "Your email",
                  controller: emailController,
                  isNotEditable: false,
                ),
                const Text(
                  "You'll need to confirm this email later.",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                LabeledInputField(
                  label: "Create a password",
                  hintText: "Enter Your Password",
                  controller: passwordController,
                  isPassword: true,
                  isNotEditable: false,
                ),
                const Text(
                  "Use a strong password for your account",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                LabeledInputField(
                  label: "Confirm Password",
                  hintText: "Confirm Your Password",
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
                  child: Obx(() {
                    if (registrationController.isLoading.value) {
                      return const CircularProgressIndicator();
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          _onSubmit();
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

  // Method to handle the submission of the registration form
  void _onSubmit() {
    final userName = userNameController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (userName.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorAlert("Error", "All fields are required");
      return;
    }

    if (password != confirmPassword) {
      _showErrorAlert("Error", "Passwords do not match");
      return;
    }

    // Registering the user using the RegistrationController
    registrationController
        .registerUser(
      userName,
      password,
      email,
      firstName,
      lastName,
    )
        .then((_) {
      if (registrationController.errorMessage.isNotEmpty) {
        _showErrorAlert("Error", registrationController.errorMessage.value);
      }
    });
  }

  // Method to show an alert dialog with an error message
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
}
