import 'dart:developer';

import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/category_list_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_list_controller.dart';
import 'package:allwork/widgets/daily_date_widget.dart';
import 'package:allwork/widgets/prayer_time_widget.dart';
import 'package:intl/intl.dart';

class MenuDetailView extends StatefulWidget {
  final String menuItem;
  final String selectedLanguage;

  const MenuDetailView({
    super.key,
    required this.menuItem,
    required this.selectedLanguage,
  });

  @override
  State<MenuDetailView> createState() => _MenuDetailViewState();
}

class _MenuDetailViewState extends State<MenuDetailView> {
  final controller = Get.put(CategoryListController());
  @override
  void initState() {
    super.initState();
    controller.fetchCategoryData(widget.menuItem);
  }

  @override
  Widget build(BuildContext context) {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());
    final fontFamily =
        widget.selectedLanguage == 'English' ? 'Roboto' : 'Gopika';

    Future<void> refreshCategoryData() async {
      // Fetch the latest category data
      await controller.fetchCategoryData(widget.menuItem);
    }

    return BackgroundWrapper(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundBlue,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (controller.categoryData.isEmpty) {
          return const Center(
              child: Text(
            "No categories available",
            style: AppTextStyles.whiteBoldText,
          ));
        } else if (controller.isItemSingle.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            log("I will navigate to CategoryListView MLV");
            Get.off(() => CategoryListView(
                  categoryItems: controller.categoryData[""] ?? [],
                  argument: widget.menuItem,
                  selectedLanguage: widget.selectedLanguage,
                  menuItem: widget.menuItem,
                ));
          });
          return Scaffold(
            backgroundColor: AppColors.backgroundBlue,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: AppColors.backgroundBlue,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundBlue,
              centerTitle: true,
              title: Text(
                widget.menuItem,
                style: AppTextStyles.customStyle(
                  fontFamily: fontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
                size: 30,
              ),
            ),
            body: RefreshIndicator(
              onRefresh: refreshCategoryData,
              child: ListView(
                children: [
                  if (widget.menuItem == "Daily Dua" ||
                      widget.menuItem == "રોજની દોઆઓ")
                    Center(
                      child: Text(
                        "Day: $dayOfWeek",
                        style: AppTextStyles.whiteBoldText,
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: DailyDateWidget()),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PrayerTimeWidget(),
                  ),
                  ...List.generate(controller.categoryData.length, (index) {
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
                                  style: AppTextStyles.customStyle(
                                    fontFamily: fontFamily,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.backgroundBlue,
                                  ),
                                ),
                              ),
                              onTap: () {
                                log("menu detail view-------> $categoryName");
                                Get.to(
                                  () => CategoryListView(
                                    categoryItems:
                                        controller.categoryData[categoryName]!,
                                    argument: categoryName,
                                    selectedLanguage: widget.selectedLanguage,
                                    menuItem: widget.menuItem,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10)
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
