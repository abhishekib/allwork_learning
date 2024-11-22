import 'package:flutter/material.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/labeled_input_field_widget.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  // Controllers for the form inputs
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Password field
              LabeledInputField(
                label: "Current Password",
                hintText: "Enter Current Password",
                controller: currentPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 10),

              // New Password field
              LabeledInputField(
                label: "New Password",
                hintText: "Enter New Password",
                controller: newPasswordController,
                isPassword: true,
              ),
              const Text(
                "Use a strong password for your account",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10),

              // Confirm New Password field
              LabeledInputField(
                label: "Confirm New Password",
                hintText: "Confirm New Password",
                controller: confirmPasswordController,
                isPassword: true,
              ),
              const Text(
                "Use a strong password for your account",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add your submit logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
      ),
    );
  }
}
