import 'package:allwork/modals/category_response.dart';
import 'package:allwork/modals/category_response2.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/menu_helpers/helpers.dart';
import 'package:get/state_manager.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/providers/category_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class CategoryListController extends GetxController {
  var categoryData = <String, List<Category>>{}.obs;
  var isLoading = true.obs;
  var isItemSingle = false.obs;
  var categoryData2 = <String, dynamic>{}.obs;

  var isItemNested = false.obs;

  final CategoryProvider _categoryProvider =
      CategoryProvider(ApiConstants.token);

  Future<void> fetchCategoryData(String menuItem) async {
    isLoading(true);
    final endpoint = _getEndpointForMenuItem(menuItem);

    if (endpoint == ApiConstants.ziyaratEndpoint) {
      await fetchCategoryDataZiyarat(endpoint);
    } else {
      await fetchCategoryDataNormal(endpoint);
    }
  }

  Future<void> fetchCategoryDataNormal(String endpoint) async {
    try {
      if (endpoint.isNotEmpty) {
        String? dayOfWeek;

        if (endpoint == "Daily Dua" || endpoint == "રોજની દોઆઓ") {
          dayOfWeek = DateFormat('EEEE').format(DateTime.now()).toLowerCase();
        }

        CategoryResponse response;
        if (await Helpers.hasActiveInternetConnection()) {
          log("Active internet connection present");
          response =
              await _categoryProvider.fetchCategoryData(endpoint, dayOfWeek);
        } else {
          log("Active internet connection not present");
          log(endpoint);
          response = DbServices.instance.getCategoryResponse(endpoint)!;
        }
        categoryData.value = response.categories;
        isItemSingle.value = categoryData.keys.firstOrNull == '';
      } else {
        log("No endpoint found for $endpoint");
      }
    } catch (e) {
      log("Error fetching category data for $endpoint: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategoryDataZiyarat(String endpoint) async {
    try {
      if (endpoint.isNotEmpty) {
        String? dayOfWeek;

        CategoryResponse2 response;
        Map<String, dynamic> map = {};
        if (await Helpers.hasActiveInternetConnection()) {
          log("Active internet connection present");
          response =
              await _categoryProvider.fetchCategoryData2(endpoint, dayOfWeek);

          map["Ziyarat 14 Masoomeen"] = response.ziyarat14Masoomeen;
          map["Other Ziyarats"] = response.otherZiyarats;
        } else {
          log("Active internet connection not present");
          log(endpoint);
          //response = DbServices.instance.getCategoryResponse(endpoint)!;
        }
        categoryData2.value = map;
        isItemNested(true);
      } else {
        log("No endpoint found for $endpoint");
      }
    } catch (e) {
      log("Error fetching category data for $endpoint: $e");
    } finally {
      isLoading(false);
    }
  }

  // This function dynamically returns the endpoint URL for each menu item
  String _getEndpointForMenuItem(String endpoint) {
    switch (endpoint) {
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
      case "રોન ોઆઓ":
        return ApiConstants.gujaratiDailyDuaEndpoint;
      case "સુરાહ":
        return ApiConstants.gujaratiSurahEndpoint;
      case "દોઆઓ":
      case "ોઆઓ":
        return ApiConstants.gujaratiDuaEndpoint;
      case "ઝિયરાત":
      case "ઝિયાત":
        return ApiConstants.gujaratiZiyaratEndpoint;
      // case "અમલ":
      // return ApiConstants.amaalEndpoint;
      case "મુનાજાત":
      case "ુનાજાત":
        return ApiConstants.gujaratiMunajatEndpoint;
      // case "Travel Ziyarat":
      // return ApiConstants.travelZiyaratEndpoint;
      default:
        return ApiConstants.baseUrl;
    }
  }
}
