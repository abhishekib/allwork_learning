import 'dart:developer';

import 'package:allwork/modals/menu_list.dart';
import 'package:allwork/providers/menu_service.dart';
import 'package:allwork/utils/constants.dart';
import 'package:get/state_manager.dart';

class MenuListController extends GetxController {
  var menuList = MenuList(items: []).obs;
  var isLoading = true.obs;

  final MenuService _menuService = MenuService(ApiConstants.token);
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchMenuItems();
  }

  void fetchMenuItems() async {
    try {
      isLoading(true);
      menuList.value = await _menuService.fetchMenuList();
    } catch (e) {
      log("menu list controller error----> $e");
    } finally {
      isLoading(false);
    }
  }

  // Map each menu item to its specific endpoint
  final Map<String, String> itemEndpoints = {
    "Daily Dua": "${ApiConstants.baseUrl}/${ApiConstants.dailyDuaEndpoint}",
    // "Surah": "${ApiConstants.baseUrl}/${ApiConstants.dailyDuaEndpoint}",
    "Dua": "${ApiConstants.baseUrl}/${ApiConstants.duas}",
    "Ziyarat": "${ApiConstants.baseUrl}/${ApiConstants.ziyaratEndpoint}",
    // "Amaal": "${ApiConstants.baseUrl}/${ApiConstants.dailyDuaEndpoint}",
    "Munajat": "${ApiConstants.baseUrl}/${ApiConstants.munajatEndpoint}",
    // "Travel Ziyarat": "${ApiConstants.baseUrl}/${ApiConstants.dailyDuaEndpoint}",
  };
}
