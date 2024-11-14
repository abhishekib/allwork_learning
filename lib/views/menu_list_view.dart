import 'dart:developer';

import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/menu_detail_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/menu_list_controller.dart';

class MenuListView extends StatelessWidget {
  const MenuListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MenuListController());

    Future<void> refreshMenuItems() async {
      // Call the controller method to fetch the menu list again
      controller.fetchMenuItems();
    }

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.backgroundBlue,
          title: const Text(
            "Menu List",
            style: AppTextStyles.whiteBoldTitleText,
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.menuList.value.items.isEmpty) {
            return const Center(child: Text("No menu items available"));
          } else {
            return RefreshIndicator(
              onRefresh: refreshMenuItems,
              child: ListView.builder(
                itemCount: controller.menuList.value.items.length,
                itemBuilder: (context, index) {
                  final menuItem = controller.menuList.value.items[index];
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
      ),
    );
  }
}
