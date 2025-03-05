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

  String _getEndpoint(String menuItem, {bool isFetching = true}) {
    final Map<String, String> fetchEndpoints = {
      "Daily Dua": ApiConstants.listFavDailyDua,
      "Surah": ApiConstants.listFavSuraha,
      "Dua": ApiConstants.listFavDua,
      "Ziyarat": ApiConstants.listFavZiyarat,
      "Amaal & Namaz": ApiConstants.listFavAmaalNamaaz,
      "Munajat": ApiConstants.listFavMunajat,
      "Travel Ziyarat": ApiConstants.listFavTravelZiyarat,
    };

    final Map<String, String> addEndpoints = {
      "Daily Dua": ApiConstants.addFavdailydua,
      "Surah": ApiConstants.addFavSurah,
      "Dua": ApiConstants.addFavdua,
      "Ziyarat": ApiConstants.addFavziyarat,
      "Munajat": ApiConstants.addFavmunajat,
      "Travel Ziyarat": ApiConstants.addFavTravelZiyarat,
      "રોજની દોઆઓ": ApiConstants.addFavdailydua,
      "સુરાહ": ApiConstants.addFavSurah,
      "દોઆઓ": ApiConstants.addFavdua,
      "ઝિયરાત": ApiConstants.addFavziyarat,
      "મુનાજાત": ApiConstants.addFavmunajat,
      "મુકદ્દસ મઝારાતની ઝિયારાત": ApiConstants.addFavTravelZiyarat,
    };

    if (isFetching) {
      return fetchEndpoints[menuItem] ?? ApiConstants.baseUrl;
    } else {
      return addEndpoints[menuItem] ?? ApiConstants.baseUrl;
    }
  }

  Future<String> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    log("Fetched userId: $userId");
    return userId;
  }

  Future<void> fetchFavouriteItems(String menuItem) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final endpoint = _getEndpoint(menuItem);

      String userId = await _getUserId();

      if (userId.isEmpty) {
        throw Exception("User ID is empty");
      }

      var fetchedItems =
          await _favouriteProvider.fetchFavouriteList(endpoint, userId);
      favouriteItems.value = fetchedItems;

      log("Mapped Favourite Items: ${favouriteItems.length}");
      log(favouriteItems.toString());
    } catch (e) {
      log("Error fetching favourite items: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToFavourite(String menuItem, int itemId) async {
    try {
      String userId = await _getUserId();
      log("postId--[provider]-------->$itemId");

      if (userId.isEmpty) {
        throw Exception('User is not logged in');
      }

      String endpoint = _getEndpoint(menuItem, isFetching: false);

      bool success =
          await _favouriteProvider.addToFavourite(endpoint, userId, itemId);

      if (success) {
        log('Item added to favourites successfully!');
        fetchFavouriteItems(menuItem);
      } else {
        log('Failed to add item to favourites.');
      }
    } catch (e) {
      log('Error adding to favourites: $e');
    }
  }

  void resetState() {
    favouriteItems.clear();
    isLoading.value = true;
    hasError.value = false;
  }
}
