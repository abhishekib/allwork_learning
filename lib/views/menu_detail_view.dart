import 'dart:developer';

import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/category_response.dart';
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
  Map<String, CategoryResponse>? nestedResponse;
  bool? repeated;

  MenuDetailView(
      {super.key,
      required this.menuItem,
      required this.selectedLanguage,
      this.nestedResponse,
      this.repeated});

  @override
  State<MenuDetailView> createState() => _MenuDetailViewState();
}

class _MenuDetailViewState extends State<MenuDetailView> {
  final controller = Get.put(CategoryListController());
  @override
  void initState() {
    super.initState();
    //if the menu detail view is called with screen repetation then no need to fetch the data again
    if (!(widget.repeated ?? false)) {
      controller.fetchCategoryData(widget.menuItem);
    } else {}
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

//if the menu detail view is called with screen repetation then load only nested response
    if (widget.repeated ?? false) {
      return BackgroundWrapper(
        child: Scaffold(
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: DailyDateWidget()),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: PrayerTimeWidget(),
                ),
                ...List.generate(
                    widget.nestedResponse!.values.first.categories.length,
                    (index) {
                  final categoryName = widget
                      .nestedResponse!.values.first.categories.keys
                      .elementAt(index);
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
                                //categoryName,
                                style: AppTextStyles.customStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.backgroundBlue,
                                ),
                              ),
                            ),
                            onTap: () {
                              log("menu detail view-------> $categoryName");
                              final category = widget.nestedResponse!.values
                                  .first.categories.values
                                  .elementAt(index);
                              log("Tapped on $category");
                              Get.to(
                                () => CategoryListView(
                                  categoryItems: category,
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
        ),
      );
    } else {
      return BackgroundWrapper(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Scaffold(
              backgroundColor: AppColors.backgroundBlue,
              appBar: AppBar(
                backgroundColor: AppColors.backgroundBlue,
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
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          } else if (controller.categoryData.isEmpty &&
              controller.categoryResponse2 == null) {
            return Scaffold(
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
              body: Center(
                  child: Text(
                widget.selectedLanguage == 'English'
                    ? "No record found"
                    : "કોઈ રેકોર્ડ મળ્યો નથી",
                style: AppTextStyles.whiteBoldText,
              )),
            );
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
          } else if (controller.isNestedData.value) {
            controller.isNestedData(false);
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: DailyDateWidget()),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: PrayerTimeWidget(),
                    ),
                    ...List.generate(
                        controller.categoryResponse2.toMap().keys.length,
                        (index) {
                      final categoryName = controller.categoryResponse2
                          .toMap()
                          .keys
                          .elementAt(index);
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                                      fontFamily: 'Roboto',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.backgroundBlue,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  log("menu detail view-------> $categoryName");
// Retrieve the map from categoryResponse2 once to avoid redundant calls
                                  final categoryMap =
                                      controller.categoryResponse2.toMap();

// Get the key at the current index
                                  final currentKey =
                                      categoryMap.keys.elementAt(index);

                                  if (controller.categoryResponse2
                                      .toMap()
                                      .values
                                      .elementAt(index) is Map) {
                                    log("Tapped on Ziyarat 14 Masoomeen");
                                    log("Data going to the menu detail screen ${controller.categoryResponse2.toMap()["Ziyarat 14 Masoomeen"]}");
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
// Access the value corresponding to the current key
                                      final value = categoryMap[currentKey];

                                      return MenuDetailView(
                                          menuItem: widget.menuItem,
                                          selectedLanguage:
                                              widget.selectedLanguage,
                                          repeated: true,
                                          nestedResponse: value);
                                    }
                                            //["Ziyarat 14 Masoomeen"]

                                            ));
                                  } else {
                                    log("Tapped on other ziyarats");
                                    log(controller.categoryResponse2
                                        .toMap()
                                        .values
                                        .toList()[1]
                                        .toString());

                                    final firstCategoryValue =
                                        categoryMap[currentKey]
                                            .categories
                                            .values
                                            .first;
                                    Get.to(
                                      () => CategoryListView(
                                        categoryItems: firstCategoryValue,
                                        argument: categoryName,
                                        selectedLanguage:
                                            widget.selectedLanguage,
                                        menuItem: widget.menuItem,
                                      ),
                                    );
                                  }
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                                      fontFamily: 'Roboto',
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
                                      categoryItems: controller
                                          .categoryData[categoryName]!,
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
}
