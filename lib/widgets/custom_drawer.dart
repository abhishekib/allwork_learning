import 'package:allwork/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:allwork/utils/colors.dart';

class CustomDrawer extends StatelessWidget {
  final bool isLoggedIn; // This determines whether the user is logged in or not

  const CustomDrawer({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundBlue,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: AppColors.backgroundBlue,
          //   ),
          //   child: const Text(
          //     'Menu',
          //     style: AppTextStyles.whiteBoldText,
          //   ),
          // ),
          SizedBox(height: 20),
          if (!isLoggedIn) ...[
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
                Navigator.pop(context);
                // Implement signup navigation
              },
            ),
          ],
          if (isLoggedIn) ...[
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
              // Implement favourite navigation
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
              // Implement our radio navigation
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
              // Optional: Navigate to a list of apps or open a submenu
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
                    // Implement My Dua Online navigation
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
                    // Implement Azadar navigation
                  },
                ),
              ],
            ),
          ),
          if (isLoggedIn) ...[
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
                Navigator.pop(context);
                // Implement logout function
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
                // Implement account deletion
              },
            ),
          ],
        ],
      ),
    );
  }
}
