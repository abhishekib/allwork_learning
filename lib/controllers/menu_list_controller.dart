import 'package:allwork/modals/menu_list.dart';
import 'package:allwork/providers/menu_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:get/state_manager.dart';
import 'dart:developer';

class MenuListController extends GetxController {
  var menuList = MenuList(items: []).obs;
  var gujaratiMenuList = MenuList(items: []).obs;
  var isLoading = true.obs;

  final MenuService _menuService = MenuService(ApiConstants.token);

  @override
  void onInit() {
    super.onInit();
    fetchMenuItems();
  }

  // Fetch the menu items and store in `menuList`
  void fetchMenuItems() async {
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
}
