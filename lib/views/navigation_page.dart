import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/amaal_controller.dart';
import 'package:allwork/views/subcategory_page.dart';

class NavigationPage extends StatelessWidget {
  final AmaalController controller = Get.put(AmaalController());
  final String menuItem;

  NavigationPage({required this.menuItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundBlue,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          menuItem,
          style: AppTextStyles.whiteBoldTitleText,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: AppTextStyles.whiteBoldText,
            ),
          );
        }

        // Navigate directly into the 'data' key
        final data = controller.amaalModel.value.data?['data'];

        if (data == null || data.isEmpty) {
          return const Center(
            child: Text(
              "No categories available",
              style: AppTextStyles.whiteBoldText,
            ),
          );
        }

        final categories = data.keys.toList();

        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final items = data[category];

            return ListTile(
              title: Text(
                category,
                style: AppTextStyles.whiteBoldText,
              ),
              onTap: () {
                if (items is Map) {
                  // Navigate to SubcategoryPage if items is a Map
                  Get.to(() => SubcategoryPage(
                        category: category,
                        items: items,
                      ));
                } else if (items is List) {
                  // For List (like in Rajab), navigate directly to DetailPage for each item
                  Get.to(() => SubcategoryPage(
                        category: category,
                        items: items,
                      ));
                } else {
                  // Handle case for invalid structure
                  Get.snackbar(
                    "Error",
                    "Unable to navigate to the selected category.",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            );
          },
        );
      }),
    );
  }
}
