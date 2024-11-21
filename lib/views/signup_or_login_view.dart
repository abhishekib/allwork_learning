import 'package:allwork/views/signup_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';

class SignUpOrLoginView extends StatelessWidget {
  SignUpOrLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBlue,
          title: const Text(
            '',
            style: AppTextStyles.whiteBoldTitleText,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: BoxDecoration(color: AppColors.backgroundBlue),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up or Login',
                  style: AppTextStyles.whiteBoldTitleText,
                ),
                const Text(
                  'Sign up to add favorite',
                  style: TextStyle(
                      color: Color.fromARGB(255, 226, 226, 226),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => SignUpView()); // Navigate to Sign Up view
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Sign Up for Free',
                    style: TextStyle(
                      color: AppColors.backgroundBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(
                      color: Colors.white,
                      thickness: 100,
                    ),
                    Text(
                      'or',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login with',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Get.to(() => LoginView()); // Navigate to Login view
                  },
                  icon: const Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Continue with Email',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
