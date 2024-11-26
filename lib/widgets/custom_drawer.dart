import 'package:allwork/controllers/login_controller.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/about_us_view.dart';
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
                  // ListTile(
                  //   leading: const Icon(
                  //     Icons.radio,
                  //     color: Colors.white,
                  //   ),
                  //   title: const Text(
                  //     'Our Radio',
                  //     style: AppTextStyles.whiteBoldText,
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
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
                        // Show a customized confirmation dialog before deleting account
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: AppColors
                                  .backgroundBlue, // Custom background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded corners
                              ),
                              title: Row(
                                children: [
                                  const Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Confirm Account Deletion',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'Are you sure you want to delete your account?',
                                style: TextStyle(
                                  color: Colors
                                      .white70, // Subtle content text color
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Rounded corners for the button
                                    ),
                                    foregroundColor: AppColors.backgroundBlue,
                                    backgroundColor:
                                        Colors.white, // Button color
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: AppColors
                                          .backgroundBlue, // Subtle content text color
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    loginController.deleteAccount();
                                    loginController.logoutUser();
                                    Navigator.of(context).pop();
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red, // Button color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Rounded corners for the button
                                    ),
                                  ),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
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
                      Icons.info,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'About Us',
                      style: AppTextStyles.whiteBoldText,
                    ),
                    onTap: () {
                      Get.to(() => AboutUsView());
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
                    // Show a customized confirmation dialog before logging out
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: AppColors
                              .backgroundBlue, // Custom background color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Rounded corners
                          ),
                          title: Row(
                            children: [
                              const Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Confirm Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          content: const Text(
                            'Are you sure you want to log out?',
                            style: TextStyle(
                                color:
                                    Colors.white70, // Subtle content text color
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), // Rounded corners for the button
                                  ),
                                  foregroundColor: AppColors.backgroundBlue,
                                  backgroundColor:
                                      Colors.white // Text color for the button
                                  ),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                loginController
                                    .logoutUser(); // Call the logout function
                                Navigator.of(context).pop(); // Close the dialog
                                Navigator.pop(
                                    context); // Optionally close the current screen
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // Button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Rounded corners for the button
                                ),
                              ),
                              child: const Text(
                                'Yes',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
