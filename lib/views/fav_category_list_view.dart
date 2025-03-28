import 'dart:developer';
import 'package:allwork/modals/category.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/favourite_controller.dart';
import 'package:allwork/modals/favourite_model.dart';
import 'package:allwork/views/amaal_details_screen.dart';
import 'package:allwork/views/category_detail_view.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavCategoryListView extends StatefulWidget {
  final String menuItem;
  const FavCategoryListView({super.key, required this.menuItem});

  @override
  _FavCategoryListViewState createState() => _FavCategoryListViewState();
}

class _FavCategoryListViewState extends State<FavCategoryListView> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final FavouriteController favouriteController =
        Get.put(FavouriteController());

    favouriteController.fetchFavouriteItems(widget.menuItem);

    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Favourite ${widget.menuItem == "Surah" ? "The Holy Quran" : widget.menuItem == "સુરાહ" ? "કુરાન" : widget.menuItem}",
              style: AppTextStyles.whiteBoldTitleText,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = !isEditing;
                });
                if (!isEditing) {
                  _saveOrder(favouriteController.favouriteItems);
                }
              },
            )
          ],
        ),
        body: Obx(() {
          if (favouriteController.isLoading.value) {
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (favouriteController.hasError.value) {
            return Center(
                child: Text('Error fetching favourite data.',
                    style: AppTextStyles.whiteBoldText));
          }

          if (favouriteController.favouriteItems.isEmpty) {
            return Center(
                child: Text('No favourite categories available.',
                    style: AppTextStyles.whiteBoldText));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final item =
                    favouriteController.favouriteItems.removeAt(oldIndex);
                favouriteController.favouriteItems.insert(newIndex, item);
                _saveOrder(favouriteController.favouriteItems);
              },
              children: List.generate(favouriteController.favouriteItems.length,
                  (index) {
                final favouriteItem = favouriteController.favouriteItems[index];
                favouriteItem.menuItem = widget.menuItem;

                return Column(
                  key: Key('$index'),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9.5),
                      ),
                      child: ListTile(
                        title: Text(
                          TextCleanerService.cleanText(favouriteItem.title),
                          style: AppTextStyles.blueBoldText,
                        ),
                        onTap: () {
                          if (widget.menuItem == "Amaal") {
                            Get.to(() => AmaalDetailsScreen(
                                    item: Category(
                                  data: favouriteItem.data,
                                  category: "",
                                  id: int.parse(favouriteItem.id),
                                  title: favouriteItem.title,
                                  isFav: "Yes",
                                )));
                          } else {
                            Get.to(() => CategoryDetailView(),
                                arguments: favouriteItem);
                          }
                        },
                        trailing: isEditing
                            ? ReorderableDragStartListener(
                                index: index,
                                child: Icon(Icons.drag_handle),
                              )
                            : Container(
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
                    SizedBox(height: 10),
                  ],
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _saveOrder(List<FavouriteModel> favouriteItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> orderedIds = favouriteItems.map((e) => e.id).toList();
    await prefs.setStringList('favourite_order_${widget.menuItem}', orderedIds);
    log("Saved favourite order: $orderedIds");
  }
}
