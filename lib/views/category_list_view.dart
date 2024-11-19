import 'dart:developer';

import 'package:allwork/controllers/text_cleaner_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/modals/category.dart';

class CategoryListView extends StatelessWidget {
  final List<Category> categoryItems;
  final String argument; // This field will store the menuItem value

  const CategoryListView(
      {super.key, required this.categoryItems, required this.argument});

  @override
  Widget build(BuildContext context) {
    TextCleanerController textCleanerController = TextCleanerController();
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBlue,
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            textCleanerController.cleanText(argument),
            style: AppTextStyles.whiteBoldTitleText,
          ), // Display the selected menu title here
        ),
        body: ListView.builder(
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            final item = categoryItems[index];
            return ListTile(
              title: Text(
                textCleanerController.cleanText(item.title),
                style: AppTextStyles.whiteBoldText,
              ),
              onTap: () {
                log("Category List View------>${item.title}");
                Get.toNamed(
                  '/category-detail',
                  arguments: item,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
