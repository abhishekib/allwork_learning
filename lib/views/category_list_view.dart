import 'dart:developer';

import 'package:allwork/controllers/category_list_controller.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/amaal_details_screen.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/modals/category.dart';

class CategoryListView extends StatelessWidget {
  final List<dynamic> categoryItems;
  final String argument; // This field will store the menuItem value
  final CategoryListController categoryListController =
      CategoryListController();
  final String selectedLanguage;
  final String menuItem;

  CategoryListView({
    super.key,
    required this.categoryItems,
    required this.argument,
    required this.selectedLanguage,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    final fontFamily = selectedLanguage == 'English' ? 'Roboto' : 'Gopika';
    // Get.lazyPut(() => AudioController());
    //log(categoryItems.toString());

    return BackgroundWrapper(
      child: categoryListController.isLoading.value
          ? Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.white,
                  size: 30,
                ),
                title: FittedBox(
            fit: BoxFit.scaleDown,
                  child: Text(
                    TextCleanerService.cleanText(argument),
                    style: AppTextStyles.customStyle(
                      fontFamily: fontFamily,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
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
                              TextCleanerService.cleanText(item['title']),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.customStyle(
                                fontFamily: fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.backgroundBlue,
                              ),
                            ),
                            onTap: () {
                              log("Category List View------>${item['title']}");

                              final category = Category.fromJson(item);

                              log(category.toString());

                              //  log(menuItem);
                              if (menuItem == 'Amaal' || menuItem == "અમલ") {
                                Get.to(AmaalDetailsScreen(item: category), arguments: {
                                    'language': selectedLanguage,
                                    'menuItem': menuItem
                                  });
                              } else {
                                Get.toNamed(
                                  '/category-detail',
                                  arguments: {
                                    'category': category,
                                    'language': selectedLanguage,
                                    'menuItem': menuItem
                                  },
                                );
                              }
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              children: [
                                Container(
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10)
                      ],
                    );
                  },
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
    );
  }
}
