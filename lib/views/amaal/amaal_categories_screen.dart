import 'package:allwork/controllers/amaal_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/amaal/amaal_subcategories_screen.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:allwork/widgets/daily_date_widget.dart';
import 'package:allwork/widgets/prayer_time_widget.dart';
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

          return ListView(children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: DailyDateWidget()),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: PrayerTimeWidget(),
            ),
            ...List.generate(categories.length, (index) {
              final category = categories[index];
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9.5),
                    ),
                    child: ListTile(
                      title: Center(
                        child: Text(category.name,
                            style: AppTextStyles.customStyle(
                              fontFamily: 'Roberto',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.backgroundBlue,
                            )),
                      ),
                      onTap: () {
                        Get.to(
                            () => AmaalSubcategoriesScreen(category: category));
                      },
                    ),
                  ),
                  const SizedBox(height: 10)
                ],
              );
            }),
          ]);
        }),
      ),
    );
  }
}
