import 'package:allwork/controllers/login_controller.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/signup_or_login_view.dart';
import 'package:flutter/material.dart';
import 'package:allwork/utils/colors.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  // Get the same LoginController instance using Get.put()
  final LoginController loginController = Get.put(LoginController());

  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundBlue,
      child: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 20),
            // If logged in, display a header with the user's name
            if (loginController.isLoggedIn.value) ...[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.backgroundBlue,
                ),
                accountName: Text(
                  loginController
                          .loginResponse.value?.message.data.displayName ??
                      '',
                  style: AppTextStyles.whiteBoldText,
                ),
                accountEmail: Text(
                  loginController.loginResponse.value?.message.data.userEmail ??
                      '',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    loginController
                            .loginResponse.value?.message.data.displayName[0] ??
                        '',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: AppColors.backgroundBlue,
                    ),
                  ),
                ),
              ),
            ],
            if (!loginController.isLoggedIn.value) ...[
              ListTile(
                leading: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                title: const Text(
                  'Signup',
                  style: AppTextStyles.whiteBoldText,
                ),
                onTap: () {
                  Get.to(SignUpOrLoginView());
                },
              ),
            ],
            if (loginController.isLoggedIn.value) ...[
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: const Text(
                  'Profile',
                  style: AppTextStyles.whiteBoldText,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Implement profile navigation
                },
              ),
            ],
            ListTile(
              leading: const Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              title: const Text(
                'Favourite',
                style: AppTextStyles.whiteBoldText,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.radio,
                color: Colors.white,
              ),
              title: const Text(
                'Our Radio',
                style: AppTextStyles.whiteBoldText,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.apps,
                color: Colors.white,
              ),
              title: const Text(
                'Explore More Apps',
                style: AppTextStyles.whiteBoldText,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'My Dua Online',
                      style: AppTextStyles.whiteBoldText,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Azadar',
                      style: AppTextStyles.whiteBoldText,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            if (loginController.isLoggedIn.value) ...[
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: const Text(
                  'Logout',
                  style: AppTextStyles.whiteBoldText,
                ),
                onTap: () {
                  loginController.isLoggedIn.value = false;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                title: const Text(
                  'Delete Account',
                  style: AppTextStyles.whiteBoldText,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
