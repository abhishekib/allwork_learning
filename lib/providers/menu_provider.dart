import 'package:allwork/services/db_services.dart';
import 'package:dio/dio.dart';
import 'package:allwork/modals/menu_list.dart';
import '../utils/constants.dart';

class MenuService {
  final Dio _dio;

  MenuService(String token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            // connectTimeout: const Duration(milliseconds: 15000),
            // receiveTimeout: const Duration(milliseconds: 3000),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );

  Future<MenuList> fetchMenuList() async {
    final response = await _dio.get(ApiConstants.menuEndpoint);

    if (response.statusCode == 200) {
      MenuList menuList = MenuList.fromJson(response.data);

      DbServices.instance.writeMenuList(menuList);

      return menuList;
    } else {
      throw Exception('Failed to fetch menu list');
    }
  }

  Future<MenuList> fetchGujaratiMenuList() async {
    final response = await _dio.get(ApiConstants.gujaratiMenuEndpoint);

    if (response.statusCode == 200) {
      MenuList menuList = MenuList.fromJson(response.data);

      DbServices.instance.writeGujratiMenuList(menuList);

      return menuList;
    } else {
      throw Exception('Failed to fetch menu list');
    }
  }
}
