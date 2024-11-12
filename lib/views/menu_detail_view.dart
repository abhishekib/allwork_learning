import 'dart:developer';

import 'package:allwork/views/category_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_list_controller.dart';

class MenuDetailView extends StatelessWidget {
  final String menuItem;

  const MenuDetailView({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryListController());

    // Fetch data if not already fetched for the selected menu item
    if (controller.categoryData.isEmpty) {
      controller.fetchCategoryData(menuItem);
    }

    Future<void> _refreshCategoryData() async {
      // Fetch the latest category data
      await controller.fetchCategoryData(menuItem);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(menuItem),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.categoryData.isEmpty) {
          return const Center(child: Text("No categories available"));
        } else {
          return RefreshIndicator(
            onRefresh: _refreshCategoryData,
            child: ListView.builder(
              itemCount: controller.categoryData.length,
              itemBuilder: (context, index) {
                final categoryName =
                    controller.categoryData.keys.elementAt(index);
                return ListTile(
                  title: Text(categoryName),
                  onTap: () {
                    log("menu detail view-------> $categoryName");
                    Get.to(
                      () => CategoryListView(
                        categoryItems: controller.categoryData[categoryName]!,
                        argument: categoryName, // Pass the selected menuItem
                      ),
                    );
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
