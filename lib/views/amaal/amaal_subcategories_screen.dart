/*
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
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9.5),
                        ),
                        child: ListTile(
                          title: Text(
                            subcategoryName,
                            style: AppTextStyles.customStyle(
                              fontFamily: 'Roberto',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.backgroundBlue,
                            ),
                          ),
                          onTap: () {
                            Get.to(() =>
                                AmaalDetailsScreen(items: subcategoryItems));
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
              )
            : ListView.builder(
                itemCount: category.items?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = category.items![index];
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9.5),
                        ),
                        child: ListTile(
                            title: Text(
                              item.title,
                              style: AppTextStyles.customStyle(
                              fontFamily: 'Roberto',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.backgroundBlue,
                            ),
                            ),
                            onTap: () {
                              Get.to(() => AmaalDetailsScreen(items: [item]));
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
                            )),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
*/