import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/category_detail_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/favourite_controller.dart';

class FavCategoryListView extends StatelessWidget {
  final String menuItem;
  const FavCategoryListView({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    final FavouriteController favouriteController =
        Get.put(FavouriteController());

    favouriteController.fetchFavouriteItems(menuItem);

    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Favourite ${menuItem == "Surah" ? "The Holy Quran" : menuItem == "સુરાહ" ? "કુરાન" : menuItem}",
                style: AppTextStyles.whiteBoldTitleText,
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (favouriteController.isLoading.value) {
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (favouriteController.hasError.value) {
            return Center(
                child: Text(
              'Error fetching favourite data.',
              style: AppTextStyles.whiteBoldText,
            ));
          }

          if (favouriteController.favouriteItems.isEmpty) {
            return Center(
                child: Text(
              'No favourite categories available.',
              style: AppTextStyles.whiteBoldText,
            ));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              itemCount: favouriteController.favouriteItems.length,
              itemBuilder: (context, index) {
                final favouriteItem = favouriteController.favouriteItems[index];

                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9.5),
                      ),
                      child: ListTile(
                        title: Text(
                          favouriteItem.title,
                          style: AppTextStyles.blueBoldText,
                        ),
                        // subtitle: Text('Tap to view details'),
                        onTap: () {
                          Get.to(() => CategoryDetailView(),
                              arguments: favouriteItem);
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
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
