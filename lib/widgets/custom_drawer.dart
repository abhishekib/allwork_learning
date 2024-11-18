import 'package:allwork/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:allwork/utils/colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundBlue,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.backgroundBlue,
            ),
            child: const Text(
              'Menu',
              style: AppTextStyles.whiteBoldText,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: const Text(
              'Home',
              style: AppTextStyles.whiteBoldText,
            ),
            onTap: () {
              Navigator.pop(context);
              // Implement navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text(
              'Settings',
              style: AppTextStyles.whiteBoldText,
            ),
            onTap: () {
              Navigator.pop(context);
              // Implement navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text(
              'About',
              style: AppTextStyles.whiteBoldText,
            ),
            onTap: () {
              Navigator.pop(context);
              // Implement navigation
            },
          ),
        ],
      ),
    );
  }
}
