import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/views/detail_page.dart';

class SubcategoryPage extends StatelessWidget {
  final String category;
  final dynamic items; // Can be Map or List

  SubcategoryPage({required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items == null ||
        (items is Map && items.isEmpty) ||
        (items is List && items.isEmpty)) {
      return Scaffold(
        appBar: AppBar(
          title: Text(category),
        ),
        body: const Center(
          child: Text("No subcategories or items available"),
        ),
      );
    }

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBlue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            category,
            style: AppTextStyles.whiteBoldTitleText,
          ),
        ),
        body: ListView(
          children: (items is Map
                  ? (items as Map<String, dynamic>).keys.toList()
                  : items as List<dynamic>)
              .map<Widget>((item) {
            final itemContent = items is Map ? items[item] : item;

            return ListTile(
              title: Text(
                items is Map ? item : (itemContent['title'] ?? "Unknown"),
                style: AppTextStyles.whiteBoldText,
              ),
              onTap: () {
                if (itemContent is Map && itemContent.containsKey('data')) {
                  // Navigate to DetailPage if 'data' key is present
                  Get.to(() => DetailPage(
                        category: category,
                        subcategory: itemContent['title'] ?? "Unknown",
                        data: itemContent['data'] ?? "No data available",
                      ));
                } else if (itemContent is List && itemContent.isNotEmpty) {
                  // For nested lists
                  final firstElement = itemContent[0];
                  Get.to(() => DetailPage(
                        category: category,
                        subcategory: firstElement['title'] ?? "Unknown",
                        data: firstElement['data'] ?? "No data available",
                      ));
                } else {
                  // Handle invalid cases gracefully
                  Get.snackbar(
                    "Error",
                    "Unable to navigate to the selected item.",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
