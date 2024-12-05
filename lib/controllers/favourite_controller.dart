import 'package:allwork/utils/constants.dart';
import 'package:get/get.dart';
import 'package:allwork/providers/favourite_provider.dart';
import 'package:allwork/modals/favourite_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class FavouriteController extends GetxController {
  var favouriteItems = <FavouriteModel>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  final FavouriteProvider _favouriteProvider =
      FavouriteProvider(ApiConstants.token);

  String _getEndpointForMenuItem(String menuItem) {
    switch (menuItem) {
      case "Daily Dua":
        return ApiConstants.listFavDailyDua;
      case "Surah":
        return ApiConstants.listFavSuraha;
      case "Dua":
        return ApiConstants.listFavDua;
      case "Ziyarat":
        return ApiConstants.listFavZiyarat;
      case "Amaal":
        return ApiConstants.listFavAmaalNamaaz;
      case "Munajat":
        return ApiConstants.listFavMunajat;
      case "Travel Ziyarat":
        return ApiConstants.listFavTravelZiyarat;
      default:
        return ApiConstants.baseUrl;
    }
  }

  Future<void> fetchFavouriteItems(String menuItem) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final endpoint = _getEndpointForMenuItem(menuItem);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId') ?? '';
      log("Fetched userId: $userId");

      if (userId.isEmpty) {
        throw Exception("User ID is empty");
      }

      var fetchedItems =
          await _favouriteProvider.fetchFavouriteList(endpoint, userId);

      favouriteItems.value = fetchedItems;

      log("Mapped Favourite Items: ${favouriteItems.length}");
    } catch (e) {
      log("Error fetching favourite items: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void resetState() {
    favouriteItems.clear();
    isLoading.value = true;
    hasError.value = false;
  }
}
