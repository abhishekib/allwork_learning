import 'package:allwork/modals/menu_list.dart';
import 'package:allwork/providers/menu_provider.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/constants.dart';
import 'package:allwork/utils/helpers.dart';
import 'package:get/state_manager.dart';
import 'dart:developer';

class MenuListController extends GetxController {
  var menuList = MenuList(items: []).obs;
  var gujaratiMenuList = MenuList(items: []).obs;
  var isLoading = true.obs;

  final MenuService _menuService = MenuService(ApiConstants.token);

  @override
  Future<void> onInit() async {
    super.onInit();
    bool hasInternet = await Helpers.hasActiveInternetConnection();
    if (hasInternet) {
      fetchMenuItemsFromAPI();
      log('Internet connection is active');
    } else {
      fetchMenuItemsFromDb();
      log('No internet connection');
    }
  }

  // Fetch the menu items and store in `menuList`
  void fetchMenuItemsFromAPI() async {
    try {
      isLoading(true);
      // Make sure the fetch method returns MenuList, not just List<String>
      menuList.value = await _menuService.fetchMenuList();
      gujaratiMenuList.value = await _menuService.fetchGujaratiMenuList();
    } catch (e) {
      log("Error fetching menu list: $e");
    } finally {
      isLoading(false);
    }
  }

  void fetchMenuItemsFromDb() async {
    try {
      isLoading(true);
      menuList.value = DbServices.instance.getMenuList();
      gujaratiMenuList.value = DbServices.instance.getGujratiMenuList();
    } catch (e) {
      log("Error fetching menu list: $e");
    } finally {
      isLoading(false);
    }
  }
}
