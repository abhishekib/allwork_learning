import 'package:allwork/modals/menu_list.dart';
import 'package:allwork/providers/menu_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:get/state_manager.dart';
import 'package:realm/realm.dart';
import 'dart:developer';

class MenuListController extends GetxController {
  var menuList = MenuList(items: []).obs;
  var gujaratiMenuList = MenuList(items: []).obs;
  var isLoading = true.obs;

  late final MenuService _menuService;

  MenuListController()
      : _menuService = MenuService(
          ApiConstants.token,
          Realm(Configuration.local([RealmMenuList.schema])),
        );

  @override
  void onInit() {
    super.onInit();
    fetchMenuItems();
  }

  void fetchMenuItems() async {
    try {
      isLoading(true); // Set loading state to true
      menuList.value = await _menuService.fetchMenuList();
      gujaratiMenuList.value = await _menuService.fetchGujaratiMenuList();
    } catch (e) {
      log("Error fetching menu list: $e");
    } finally {
      isLoading(false);
    }
  }

  void fetchCachedMenuItems() {
    try {
      isLoading(true);
      menuList.value = MenuList(
        items: _menuService
            .getCachedMenuList()
            .expand((menu) => menu.items)
            .toList(),
      );
      gujaratiMenuList.value = MenuList(
        items: _menuService
            .getCachedGujaratiMenuList()
            .expand((menu) => menu.items)
            .toList(),
      );
    } catch (e) {
      log("Error fetching cached menu list: $e");
    } finally {
      isLoading(false);
    }
  }
}
