import 'package:allwork/views/category_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/favourite_controller.dart';

class FavCategoryListView extends StatelessWidget {
  final String endpoint;
  final FavouriteController favouriteController =
      Get.find<FavouriteController>();

  FavCategoryListView({required this.endpoint});

  @override
  Widget build(BuildContext context) {
    // Fetch the data for the selected endpoint
    favouriteController.fetchFavouriteItems(endpoint);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Categories'),
      ),
      body: Obx(() {
        // Check if data is still loading
        if (favouriteController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // If there's an error, show a message
        if (favouriteController.hasError.value) {
          return Center(child: Text('Error fetching category data.'));
        }

        // If no items in the selected endpoint, show a message
        if (favouriteController.favouriteItems.isEmpty) {
          return Center(child: Text('No favourite categories available.'));
        }

        // Filter the items to display only the category titles
        return ListView.builder(
          itemCount: favouriteController.favouriteItems.length,
          itemBuilder: (context, index) {
            final favouriteItem = favouriteController.favouriteItems[index];

            // You can adjust the logic to handle how categories are displayed in the item
            return ListTile(
              title: Text(favouriteItem.title), // Display the category title
              subtitle: Text('Tap to view details'),
              onTap: () {
                // Navigate to the category detail view when tapped
                Get.to(() => CategoryDetailView());
              },
            );
          },
        );
      }),
    );
  }
}
