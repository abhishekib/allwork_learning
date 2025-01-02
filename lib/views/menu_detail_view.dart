import 'dart:developer';

import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/category_response.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/category_list_view.dart';
import 'package:allwork/views/dynamic_screen.dart';
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

  MenuDetailView({
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
    //if the menu detail view is called with screen repetation then no need to fetch the data again
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

    return Obx(
      () {
        if (controller.isLoading.value) {
          return BackgroundWrapper(
            child: Scaffold(
              backgroundColor: AppColors.backgroundBlue,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }

        final data = controller.categoryData.value.data;

        if (data.isEmpty) {
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
        }

        // Combine cities from all countries into a single map
        final Map<String, dynamic> cities = {};
        data.forEach((country, cityData) {
          cities.addAll(cityData);
        });

        if (controller.isItemSingle.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            log("I will navigate to CategoryListView MLV");
            final key = cities.keys.elementAt(0);
            final value = cities[key];
            log("Value type : ${value.runtimeType}");
            if (value is List) {
              Get.off(() => CategoryListView(
                    categoryItems: value,
                    argument: widget.menuItem,
                    selectedLanguage: widget.selectedLanguage,
                    menuItem: widget.menuItem,
                  ));
            } else if (value is Map) {
              Get.off(() => DynamicScreen(
                  menuItem: widget.menuItem,
                  selectedLanguage: widget.selectedLanguage,
                  title: key,
                  data: value as Map<String, dynamic>));
            }
          });
          controller.isItemSingle(false);
          return Scaffold(
            backgroundColor: AppColors.backgroundBlue,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return BackgroundWrapper(
            child: Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: AppColors.backgroundBlue,
                appBar: AppBar(
                    backgroundColor: AppColors.backgroundBlue,
                    centerTitle: true,
                    title: Text(widget.menuItem,
                        style: AppTextStyles.customStyle(
                          fontFamily: fontFamily,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                      size: 30,
                    )),
                body: RefreshIndicator(
                  onRefresh: refreshCategoryData,
                  child: ListView(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: DailyDateWidget()),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: PrayerTimeWidget(),
                    ),
                    ...List.generate(cities.keys.length, (index) {
                      final key = cities.keys.elementAt(index);

                      final value = cities[key];
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
                                    key,
                                    style: AppTextStyles.customStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.backgroundBlue,
                                    ),
                                  )),
                                  onTap: () {
                                    log("Screen Tapped $key");
                                    if (value is Map<String, dynamic>) {
                                      // If the next level is a map, navigate to the same screen
                                      log("first level map");
                                      Get.to(
                                          preventDuplicates: false,
                                          () => DynamicScreen(
                                                title: key,
                                                data: value,
                                                menuItem: widget.menuItem,
                                                selectedLanguage:
                                                    widget.selectedLanguage,
                                              ));
                                    } else if (value is List<dynamic>) {
                                      log("first level list");
                                      // If it's a list, navigate to a content-specific screen
                                      Get.to(
                                        () => CategoryListView(
                                          categoryItems: value,
                                          argument: key,
                                          selectedLanguage:
                                              widget.selectedLanguage,
                                          menuItem: widget.menuItem,
                                        ),
                                      );
                                    }
                                  },
                                )),
                          ),
                          const SizedBox(height: 10)
                        ],
                      );
                    })
                  ]),
                )),
          );
        }
      },
    );
  }
}
