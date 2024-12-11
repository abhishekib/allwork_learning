import 'package:allwork/modals/menu_list.dart';
import 'package:realm/realm.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart';

class MenuService {
  final Realm _realm;
  final Dio _dio;

  /// Constructor for `MenuService`
  MenuService(String token, this._realm)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );

  /// Fetch menu list from API and store in Realm
  Future<MenuList> fetchMenuList() async {
    final response = await _dio.get(ApiConstants.menuEndpoint);

    if (response.statusCode == 200) {
      final menuList = MenuList.fromJson(response.data);

      // Save to Realm
      _realm.write(() {
        final realmModel = menuList.toRealmModel();
        _realm.add(realmModel, update: true); // Update existing record if exists
      });

      return menuList;
    } else {
      throw Exception('Failed to fetch menu list');
    }
  }

  /// Fetch Gujarati menu list from API and store in Realm
  Future<MenuList> fetchGujaratiMenuList() async {
    final response = await _dio.get(ApiConstants.gujaratiMenuEndpoint);

    if (response.statusCode == 200) {
      final menuList = MenuList.fromJson(response.data);

      // Save to Realm
      _realm.write(() {
        final realmModel = menuList.toRealmModel();
        _realm.add(realmModel, update: true);
      });

      return menuList;
    } else {
      throw Exception('Failed to fetch Gujarati menu list');
    }
  }

  /// Retrieve all cached menu lists from Realm
  List<MenuList> getCachedMenuList() {
    final realmData = _realm.all<RealmMenuList>().toList();
    return realmData.map((realmModel) => MenuList.fromRealm(realmModel)).toList();
  }

  /// Retrieve all cached Gujarati menu lists from Realm
  List<MenuList> getCachedGujaratiMenuList() {
    final realmData = _realm
        .all<RealmMenuList>()
        .where((realmModel) => true) // Apply filtering logic if needed
        .toList();
    return realmData.map((realmModel) => MenuList.fromRealm(realmModel)).toList();
  }
}
