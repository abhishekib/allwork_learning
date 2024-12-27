import 'package:allwork/modals/amaal_model.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/amaal/amaal_details_screen.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AmaalSubcategoriesScreen extends StatelessWidget {
  final Category category;

  const AmaalSubcategoriesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: AppColors.backgroundBlue,
          title: Text(
            category.name,
            style: AppTextStyles.whiteBoldTitleText,
          ),
        ),
        body: category.subcategories != null
            ? ListView.builder(
                itemCount: category.subcategories!.keys.length,
                itemBuilder: (context, index) {
                  final subcategoryName =
                      category.subcategories!.keys.elementAt(index);
                  final subcategoryItems =
                      category.subcategories![subcategoryName]!;
                  return ListTile(
                    title: Text(
                      subcategoryName,
                      style: AppTextStyles.whiteBoldText,
                    ),
                    onTap: () {
                      Get.to(() => AmaalDetailsScreen(items: subcategoryItems));
                    },
                  );
                },
              )
            : ListView.builder(
                itemCount: category.items?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = category.items![index];
                  return ListTile(
                    title: Text(
                      item.title,
                      style: AppTextStyles.whiteBoldText,
                    ),
                    onTap: () {
                      Get.to(() => AmaalDetailsScreen(items: [item]));
                    },
                  );
                },
              ),
      ),
    );
  }
}
