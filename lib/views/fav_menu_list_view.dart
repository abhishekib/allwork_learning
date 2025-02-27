import 'dart:developer';

import 'package:allwork/controllers/menu_list_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/fav_category_list_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavMenuListView extends StatefulWidget {
  const FavMenuListView({super.key});

  @override
  State<FavMenuListView> createState() => _FavMenuListViewState();
}

class _FavMenuListViewState extends State<FavMenuListView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MenuListController());

    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Favourite Menu',
            style: AppTextStyles.whiteBoldTitleText,
          ),
        ),
        body: Obx(
          () {
            final menuList = controller.menuList.value;

            if (controller.isLoading.value) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            } else if (menuList.items.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    const Text(
                      "No menu items available",
                      style: AppTextStyles.whiteBoldText,
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: menuList.items.length,
                  itemBuilder: (context, index) {
                    final menuItem = menuList.items[index];
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9.5),
                          ),
                          child: ListTile(
                            textColor: AppColors.backgroundBlue,
                            title: Center(
                              child: Text(
                                menuItem == "Surah"
                                    ? "The Holy Quran"
                                    : menuItem == "સુરાહ"
                                        ? "કુરાન"
                                        : menuItem,
                                style: AppTextStyles.blueBoldText,
                              ),
                            ),
                            onTap: () async {
                              log("selected ----> $menuItem");
                              Get.to(
                                () => FavCategoryListView(
                                  menuItem: menuItem,
                                ),
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
              );
            }
          },
        ),
      ),
    );
  }
}
