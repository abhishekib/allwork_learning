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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: categoryItems.length,
            itemBuilder: (context, index) {
              final item = categoryItems[index];
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9.5),
                    ),
                    child: ListTile(
                      focusColor: Colors.purple,
                      title: Text(
                        textCleanerController.cleanText(item.title),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.blueBoldText,
                      ),
                      onTap: () {
                        log("Category List View------>${item.title}");
                        Get.toNamed(
                          '/category-detail',
                          arguments: item,
                        );
                      },
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
