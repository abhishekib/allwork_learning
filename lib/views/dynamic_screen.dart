import 'dart:developer';

import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/category_list_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DynamicScreen extends StatelessWidget {
  final String menuItem;
  final String selectedLanguage;
  final String title;
  final Map<String, dynamic> data;

  const DynamicScreen(
      {super.key,
      required this.menuItem,
      required this.selectedLanguage,
      required this.title,
      required this.data});

  @override
  Widget build(BuildContext context) {
    final fontFamily = selectedLanguage == 'English' ? 'Roboto' : 'Gopika';
    return BackgroundWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
            backgroundColor: AppColors.backgroundBlue,
            centerTitle: true,
            title: Text(menuItem,
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
        body: ListView.builder(
          itemCount: data.keys.length,
          itemBuilder: (context, index) {
            final key = data.keys.elementAt(index);
            final value = data[key];
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
                      title: Text(key,
                          style: AppTextStyles.customStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.backgroundBlue,
                          )),
                      trailing: Icon(Icons.arrow_forward),
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
                                  menuItem: menuItem,
                                  selectedLanguage: selectedLanguage));
                        } else if (value is List<dynamic>) {
                          log("first level list");
                          // If it's a list, navigate to a content-specific screen
                          Get.to(() => CategoryListView(
                              argument: key,
                              categoryItems: value,
                              menuItem: menuItem,
                              selectedLanguage: selectedLanguage));
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10)
              ],
            );
          },
        ),
      ),
    );
  }
}
