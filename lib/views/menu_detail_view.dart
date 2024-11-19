import 'dart:developer';

import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/category_list_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
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

    Future<void> refreshCategoryData() async {
      // Fetch the latest category data
      await controller.fetchCategoryData(menuItem);
    }

    return BackgroundWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBlue,
          centerTitle: true,
          title: Text(
            menuItem,
            style: AppTextStyles.whiteBoldTitleText,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 30,
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.categoryData.isEmpty) {
            return const Center(child: Text("No categories available"));
          } else {
            return RefreshIndicator(
              onRefresh: refreshCategoryData,
              child: ListView.builder(
                itemCount: controller.categoryData.length,
                itemBuilder: (context, index) {
                  final categoryName =
                      controller.categoryData.keys.elementAt(index);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9.5),
                          ),
                          child: ListTile(
                            tileColor: AppColors.backgroundBlue,
                            title: Center(
                              child: Text(
                                categoryName,
                                style: AppTextStyles.blueBoldText,
                              ),
                            ),
                            onTap: () {
                              log("menu detail view-------> $categoryName");
                              Get.to(
                                () => CategoryListView(
                                  categoryItems:
                                      controller.categoryData[categoryName]!,
                                  argument:
                                      categoryName, // Pass the selected menuItem
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
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
