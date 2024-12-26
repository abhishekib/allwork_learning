import 'package:allwork/controllers/amaal_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/amaal_subcategories_screen.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AmaalCategoriesScreen extends StatelessWidget {
  final String menuItem;

  const AmaalCategoriesScreen({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AmaalController());

    return BackgroundWrapper(
      child: Scaffold(
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
            return Center(child: CircularProgressIndicator());
          }

          final categories = controller.categories;
          if (categories.isEmpty) {
            return Center(child: Text('No Categories Found'));
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(
                  category.name,
                  style: AppTextStyles.whiteBoldText,
                ),
                onTap: () {
                  Get.to(() => AmaalSubcategoriesScreen(category: category));
                },
              );
            },
          );
        }),
      ),
    );
  }
}
