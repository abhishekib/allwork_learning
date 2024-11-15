import 'dart:developer';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/menu_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/menu_list_controller.dart';

class MenuListView extends StatelessWidget {
  final String selectedLanguage;

  const MenuListView({super.key, required this.selectedLanguage});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MenuListController());

    Future<void> refreshMenuItems() async {
      // Call the controller method to fetch the menu list again
      controller.fetchMenuItems();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: Obx(() {
        // Use the selected language to choose the appropriate list
        final menuList = selectedLanguage == 'English'
            ? controller.menuList.value
            : controller.gujaratiMenuList.value;

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (menuList.items.isEmpty) {
          return const Center(child: Text("No menu items available"));
        } else {
          return RefreshIndicator(
            onRefresh: refreshMenuItems,
            child: ListView.builder(
              itemCount: menuList.items.length,
              itemBuilder: (context, index) {
                final menuItem = menuList.items[index];
                return ListTile(
                  title: Center(
                    child: Text(
                      menuItem,
                      style: AppTextStyles.whiteBoldText,
                    ),
                  ),
                  onTap: () {
                    log("selected ----> $menuItem");
                    Get.to(() => MenuDetailView(
                          menuItem: menuItem,
                        ));
                  },
                );
              },
            ),
          );
        }
      }),
    );
  }
}
