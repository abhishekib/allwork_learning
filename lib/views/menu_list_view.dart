import 'dart:developer';
import 'package:allwork/controllers/animated_text_controller.dart';
import 'package:allwork/controllers/category_list_controller.dart';
import 'package:allwork/controllers/daily_date_controller.dart';
import 'package:allwork/controllers/prayer_time_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/category_list_view.dart';
import 'package:allwork/views/menu_detail_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/menu_list_controller.dart';

class MenuListView extends StatefulWidget {
  final String selectedLanguage;

  const MenuListView({super.key, required this.selectedLanguage});

  @override
  State<MenuListView> createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  final animatedTextController = Get.put(AnimatedTextController());
  final dailyDateController = Get.put(DailyDateController());
  final prayerTimeController = Get.put(PrayerTimeController());

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MenuListController());
    final CategoryListController categoryListController =
        Get.put(CategoryListController()); // Use Get.put to persist controller

    Future<void> refreshMenuItems() async {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("No internet connection. Please check your network.")),
        );
      } else {
        await animatedTextController.fetchTextData();
        dailyDateController.fetchDailyDate();
        prayerTimeController.fetchPrayerTimes(52.569500, -0.240530);
        controller.fetchMenuItems();
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: Obx(() {
        // Use the selected language to choose the appropriate list
        final menuList = widget.selectedLanguage == 'English'
            ? controller.menuList.value
            : controller.gujaratiMenuList.value;

        final fontFamily =
            widget.selectedLanguage == 'English' ? 'Roboto' : 'Gopika';

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (menuList.items.isEmpty) {
          return Center(
              child: Column(
            children: [
              const Text(
                "No menu items available",
                style: AppTextStyles.whiteBoldText,
              ),
              ElevatedButton(
                onPressed: refreshMenuItems,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Refresh"),
              )
            ],
          ));
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
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  onTap: () async {
                    log("selected ----> $menuItem");
                    /* await categoryListController.fetchCategoryData(menuItem);
                    final x = categoryListController.categoryData.keys.firstOrNull;
                    if(x!.isEmpty){
                      log("I will navigate to CategoryListView");
                    }else{
                      log("I will navigate to MenuDetailView");
                    }
                    log("RAW DATA : $x"); */
                    /* if (menuItem == "Surah" || menuItem == "સુરાહ") {
                      await categoryListController.fetchCategoryData(menuItem);

                      Get.to(() => CategoryListView(
                            categoryItems:
                                categoryListController.categoryData[""] ?? [],
                            argument: menuItem,
                            selectedLanguage: widget.selectedLanguage,
                            menuItem: menuItem,
                          ));
                    } else { */
                    categoryListController.categoryData.clear();
                    Get.to(() => MenuDetailView(
                        menuItem: menuItem,
                        selectedLanguage: widget.selectedLanguage));
                    //}
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
