import 'dart:developer';
import 'package:allwork/controllers/animated_text_controller.dart';
import 'package:allwork/controllers/category_list_controller.dart';
import 'package:allwork/controllers/daily_date_controller.dart';
import 'package:allwork/controllers/prayer_time_controller.dart';
import 'package:allwork/modals/menu_list.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/category_list_view.dart';
import 'package:allwork/views/menu_detail_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/menu_list_controller.dart';
import 'package:shimmer/shimmer.dart';

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
  final controller = Get.put(MenuListController());
  final categoryListController = Get.put(CategoryListController());

  @override
  void initState() {
    super.initState();

    // Load cached data initially
    controller.fetchCachedMenuItems();

    // Monitor connectivity changes
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        // If back online, fetch fresh data
        controller.fetchMenuItems();
        animatedTextController.fetchTextData();
        dailyDateController.fetchDailyDate();
        prayerTimeController.getUserLocation();
      }
    });
  }

  Future<void> refreshMenuItems() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception("No internet connection.");
      }
      controller.fetchMenuItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: Obx(() {
        if (controller.isLoading.value) {
          return buildShimmerLoading();
        }

        final menuList = widget.selectedLanguage == 'English'
            ? controller.menuList.value
            : controller.gujaratiMenuList.value;

        if (menuList.items.isEmpty) {
          return buildEmptyState(refreshMenuItems);
        }

        return buildMenuListView(menuList, refreshMenuItems);
      }),
    );
  }

  Widget buildMenuListView(
      MenuList menuList, Future<void> Function() refreshMenuItems) {
    final fontFamily =
        widget.selectedLanguage == 'English' ? 'Roboto' : 'Gopika';

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
              log("Selected item: $menuItem");
              if (menuItem == "Surah" || menuItem == "સુરાહ") {
                await categoryListController.fetchCategoryData(menuItem);
                Get.to(() => CategoryListView(
                      categoryItems:
                          categoryListController.categoryData[menuItem] ?? [],
                      argument: menuItem,
                      selectedLanguage: widget.selectedLanguage,
                      menuItem: menuItem,
                    ));
              } else {
                Get.to(() => MenuDetailView(
                      menuItem: menuItem,
                      selectedLanguage: widget.selectedLanguage,
                    ));
              }
            },
          );
        },
      ),
    );
  }

  Widget buildEmptyState(Future<void> Function() refreshMenuItems) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book, size: 50, color: Colors.white),
          const SizedBox(height: 20),
          const Text(
            "No menu items available",
            style: AppTextStyles.whiteBoldText,
          ),
          ElevatedButton(
            onPressed: refreshMenuItems,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget buildShimmerLoading() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            title: Container(
              height: 20,
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
