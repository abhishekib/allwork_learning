import 'package:allwork/utils/constants.dart';
import 'package:get/get.dart';
import 'package:allwork/providers/favourite_provider.dart';
import 'package:allwork/modals/favourite_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteController extends GetxController {
  // List of favourite items to be displayed in the menu
  var favouriteItems = <FavouriteModel>[];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllFavouriteItems();
  }

  // List of endpoints
  final List<String> endpoints = [
    ApiConstants.listFavDailyDua,
    ApiConstants.listFavDua,
    ApiConstants.listFavZiyarat,
    ApiConstants.listFavMunajat,
    ApiConstants.listFavAmaalNamaaz,
    ApiConstants.listFavTravelZiyarat,
    ApiConstants.listFavSuraha,
  ];

  // Loading state to show progress indicators
  var isLoading = true.obs;

  // Error state for handling errors
  var hasError = false.obs;

  // The list of valid menu items (those with data)
  var validMenuItems = <String>[].obs;

  final FavouriteProvider _favouriteProvider =
      FavouriteProvider(ApiConstants.token);

  // Fetch favourite items based on the selected endpoint
  Future<void> fetchFavouriteItems(String endpoint) async {
    try {
      // Set loading state to true
      isLoading.value = true;
      hasError.value = false;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId') ?? '';
      final fetchedItems =
          await _favouriteProvider.fetchFavouriteList(endpoint, userId);

      // If there is data, add this endpoint to the valid menu items
      if (fetchedItems.isNotEmpty) {
        validMenuItems.add(endpoint);
        favouriteItems.addAll(
            fetchedItems); // You can merge the fetched items into your main list if needed
      }
    } catch (e) {
      // Handle any errors during the fetch
      print("Error fetching favourite items: $e");
      hasError.value = true;
    } finally {
      // Set loading state to false when done
      isLoading.value = false;
    }
  }

  // Fetch all favourite items for the valid endpoints
  Future<void> fetchAllFavouriteItems() async {
    // Loop through all the endpoints
    for (var endpoint in endpoints) {
      await fetchFavouriteItems(endpoint);
    }

    // If no valid menu items, show error
    if (validMenuItems.isEmpty) {
      hasError.value = true;
    }
  }

  // Reset the controller state, useful when navigating away from this screen
  void resetState() {
    favouriteItems.clear();
    validMenuItems.clear();
    isLoading.value = true;
    hasError.value = false;
  }
}
