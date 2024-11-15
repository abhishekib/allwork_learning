import 'package:get/state_manager.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/providers/category_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'dart:developer';

class CategoryListController extends GetxController {
  var categoryData = <String, List<Category>>{}.obs;
  var isLoading = true.obs;

  final CategoryProvider _categoryProvider =
      CategoryProvider(ApiConstants.token);

  // This method fetches data based on the selected menu item and its dynamic endpoint
  Future<void> fetchCategoryData(String menuItem) async {
    try {
      isLoading(true);
      final endpoint = _getEndpointForMenuItem(menuItem);

      if (endpoint.isNotEmpty) {
        final response = await _categoryProvider.fetchCategoryData(endpoint);
        categoryData.value = response.categories;
      } else {
        log("No endpoint found for $menuItem");
      }
    } catch (e) {
      log("Error fetching category data for $menuItem: $e");
    } finally {
      isLoading(false);
    }
  }

  // This function dynamically returns the endpoint URL for each menu item
  String _getEndpointForMenuItem(String menuItem) {
    switch (menuItem) {
      case "Daily Dua":
        return ApiConstants.dailyDuaEndpoint;
      case "Surah":
        return ApiConstants.surahEndpoint;
      case "Dua":
        return ApiConstants.duaEndpoint;
      case "Ziyarat":
        return ApiConstants.ziyaratEndpoint;
      case "Amaal":
      // return ApiConstants.amaalEndpoint;
      case "Munajat":
        return ApiConstants.munajatEndpoint;
      // case "Travel Ziyarat":
      // return ApiConstants.travelZiyaratEndpoint;
      case "રોજની દોઆઓ":
        return ApiConstants.gujaratiDailyDuaEndpoint;
      case "સુરાહ":
        return ApiConstants.gujaratiSurahEndpoint;
      case "દોઆઓ":
        return ApiConstants.gujaratiDuaEndpoint;
      case "ઝિયારાત":
        return ApiConstants.gujaratiZiyaratEndpoint;
      // case "અમલ":
      // return ApiConstants.amaalEndpoint;
      case "મુનાજાત":
        return ApiConstants.gujaratiMunajatEndpoint;
      // case "Travel Ziyarat":
      // return ApiConstants.travelZiyaratEndpoint;
      default:
        return ApiConstants.baseUrl;
    }
  }
}
