import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_detail_controller.dart';

class MenuDetailView extends StatelessWidget {
  final String menuItem;

  MenuDetailView({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryDetailController());

    // Fetch data if not already fetched for the selected menu item
    if (controller.categoryData.isEmpty) {
      controller.fetchCategoryData(menuItem);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(menuItem),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.categoryData.isEmpty) {
          return Center(child: Text("No categories available"));
        } else {
          return ListView.builder(
            itemCount: controller.categoryData.length,
            itemBuilder: (context, index) {
              final categoryName =
                  controller.categoryData.keys.elementAt(index);
              return ListTile(
                title: Text(categoryName),
                onTap: () {
                  Get.toNamed(
                    '/category-detail',
                    arguments: {
                      'menuTitle': menuItem,
                      'categoryItems': controller.categoryData[categoryName],
                    },
                  );
                },
              );
            },
          );
        }
      }),
    );
  }
}
