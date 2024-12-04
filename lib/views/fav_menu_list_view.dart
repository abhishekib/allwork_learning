import 'package:allwork/views/fav_category_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/favourite_controller.dart';

class FavMenuListView extends StatefulWidget {
  const FavMenuListView({super.key});

  @override
  State<FavMenuListView> createState() => _FavMenuListViewState();
}

class _FavMenuListViewState extends State<FavMenuListView> {
  final FavouriteController favouriteController =
      Get.put(FavouriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourite List')),
      body: Obx(() {
        // Check if data is still loading
        if (favouriteController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // If there's an error, show a message
        if (favouriteController.hasError.value) {
          return Center(child: Text('Error fetching favourite items.'));
        }

        // If no valid menu items, show an appropriate message
        if (favouriteController.validMenuItems.isEmpty) {
          return Center(child: Text('No favourite items available.'));
        }

        // Display the list of valid menu items that have data
        return ListView.builder(
          itemCount: favouriteController.validMenuItems.length,
          itemBuilder: (context, index) {
            final endpoint = favouriteController.validMenuItems[index];
            return ListTile(
              title: Text(endpoint), // Show endpoint name or any other title
              subtitle: Text('Tap to view details'),
              onTap: () {
                // Navigate to category list view when an item is clicked
                Get.to(() => FavCategoryListView(endpoint: endpoint));
              },
            );
          },
        );
      }),
    );
  }
}
