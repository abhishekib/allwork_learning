import 'dart:developer';

import 'package:allwork/modals/api_response_handler.dart';
import 'package:allwork/providers/category_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:allwork/utils/menu_helpers/helpers.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class CategoryListController extends GetxController {
  var categoryData = ApiResponseHandler(data: {}).obs;
  var isLoading = true.obs;
  var isItemSingle = false.obs;

  var isNestedData = false.obs;

  final CategoryProvider _categoryProvider =
      CategoryProvider(ApiConstants.token);

  //final AmaalProvider _amaalProvider = AmaalProvider(ApiConstants.token);

  @override
  void onInit() {
    //_amaalProvider.fetchAmaalData();
    super.onInit();
  }

  Future<void> fetchCategoryData(String menuItem) async {
    isLoading(true);
    log("menu item =$menuItem");
    final endpoint = _getEndpointForMenuItem(menuItem);
    log("endpoint=$endpoint");
    if (endpoint.isNotEmpty) {
      try {
        String? dayOfWeek;

        if (endpoint == ApiConstants.dailyDuaEndpoint ||
            endpoint == ApiConstants.gujaratiDailyDuaEndpoint) {
          dayOfWeek = DateFormat('EEEE').format(DateTime.now()).toLowerCase();
          log("dayOfWeek $dayOfWeek");
        }

        ApiResponseHandler response;
        if (await Helpers.hasActiveInternetConnection()) {
          log("Active internet connection present");
          response =
              await _categoryProvider.fetchApiResponse(endpoint, dayOfWeek);

          if (response.data['data'].length == 1) {
            isItemSingle(true);
          }

          //log("Api Response Handler successfully converted \n ${response.toString()}");
          categoryData(response);
          log("Response getting successfully saved in controller");
        } else {
          log("Active internet connection not present");
          log(endpoint);
          //response = DbServices.instance.getCategoryResponse(endpoint)!;
        }
      } catch (e) {
        log("Error fetching category data for $endpoint: $e");
      } finally {
        isLoading(false);
      }
    } else {
      log("No endpoint found for $menuItem");
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
        return ApiConstants.amaalEndpoint;
      case "Munajat":
        return ApiConstants.munajatEndpoint;
      case "Travel Ziyarat":
        return ApiConstants.travelZiyaratEndpoint;
      case "Amaal & Namaz":
        return ApiConstants.amalAndNamazEndpoint;

      case "રોજની દોઆઓ":
      case "રોજન ોઆઓ":
      case "રોન ોઆઓ":
        return ApiConstants.gujaratiDailyDuaEndpoint;
      case "સુરાહ":
        return ApiConstants.gujaratiSurahEndpoint;
      case "દોઆઓ":
      case "ોઆઓ":
        return ApiConstants.gujaratiDuaEndpoint;
      case "ઝિયારાત":
      case "ઝિાાત":
      case "ઝિયાત":
        return ApiConstants.gujaratiZiyaratEndpoint;
      case "અમ":
      case "અમલ":
        return ApiConstants.gujaratiAmaalEndpoint;
      case "મુનાજાત":
      case "મનાજાત":
      case "ુનાજાત":
        return ApiConstants.gujaratiMunajatEndpoint;
      case "મુકદ્સ મારાતી ઝયારત":
      case "મુકદ્દસ મઝારાતની ઝિયારાત":
        return ApiConstants.gujaratiTravelZiyaratEndpoint;
      case "અમલ અને નમાઝ":
        return ApiConstants.gujaratiAmalAndNamazEndpoint;
      default:
        log("No match found of endpoint for the given menu item");
        return ApiConstants.baseUrl;
    }
  }
}
