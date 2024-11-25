import 'package:allwork/controllers/login_controller.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/settings_page_view.dart';
import 'package:allwork/views/signup_or_login_view.dart';
import 'package:flutter/material.dart';
import 'package:allwork/utils/colors.dart';
import 'package:get/get.dart';
import '../views/profile_view.dart';

class CustomDrawer extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundBlue,
      child: Obx(
            () => Column(
          children: [
            const SizedBox(height: 20),

            // Main content of the drawer
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
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
                        Get.to(ProfileView());
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
                  if (loginController.isLoggedIn.value) ...[
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
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Settings',
                      style: AppTextStyles.whiteBoldText,
                    ),
                    onTap: () {
                      Get.to(() => SettingsPage());
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
                ],
              ),
            ),

            // Logout at the bottom
            if (loginController.isLoggedIn.value) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Logout',
                    style: AppTextStyles.whiteBoldText,
                  ),
                  onTap: () {
                    loginController.logoutUser();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

