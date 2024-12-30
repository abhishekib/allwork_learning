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

  late CategoryResponse2 categoryResponse2;

  var isNestedData = false.obs;

  final CategoryProvider _categoryProvider =
      CategoryProvider(ApiConstants.token);

  Future<void> fetchCategoryData(String menuItem) async {
    isLoading(true);
    log("menu item =$menuItem");
    final endpoint = _getEndpointForMenuItem(menuItem);
    log("endpoint=$endpoint");
    if (endpoint.isNotEmpty) {
      if (endpoint == ApiConstants.ziyaratEndpoint ||
          endpoint == ApiConstants.gujaratiZiyaratEndpoint) {
        log("endpoint called $endpoint");
        fetchCategoryDataZiyarat(endpoint);
      } else {
        fetchCategoryDataNormal(endpoint);
      }
    } else {
      log("No endpoint found for $menuItem");
    }
  }

  Future<void> fetchCategoryDataNormal(String endpoint) async {
    try {
      String? dayOfWeek;

      if (endpoint == ApiConstants.dailyDuaEndpoint ||
          endpoint == ApiConstants.gujaratiDailyDuaEndpoint) {
        dayOfWeek = DateFormat('EEEE').format(DateTime.now()).toLowerCase();
        log("dayOfWeek $dayOfWeek");
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
    } catch (e) {
      log("Error fetching category data for $endpoint: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategoryDataZiyarat(String endpoint) async {
    try {
      if (await Helpers.hasActiveInternetConnection()) {
        log("Active internet connection present");
        categoryResponse2 =
            await _categoryProvider.fetchCategoryData2(endpoint);
        //log(response2.toString());
        isNestedData(true);
      } else {
        log("Active internet connection not present");
        log(endpoint);
        //categoryResponse2 = DbServices.instance.getCategoryResponse2();
        //log("Saved data coming ${categoryResponse2.toString()}");
        //isNestedData(true);
      }
      //categoryData.value = response.categories;
      //isItemSingle.value = categoryData.keys.firstOrNull == '';
    } catch (e) {
      log("Error fetching category data for $endpoint: $e");
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
      case "રોન ોઆઓ":
        return ApiConstants.gujaratiDailyDuaEndpoint;
      case "સુરાહ":
        return ApiConstants.gujaratiSurahEndpoint;
      case "દોઆઓ":
      case "ોઆઓ":
        return ApiConstants.gujaratiDuaEndpoint;
      case "ઝિયારાત":
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
