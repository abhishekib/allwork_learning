import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_list_controller.dart';
import 'package:allwork/views/menu_detail_view.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final CategoryListController _categoryListController =
      Get.put(CategoryListController());

  DeepLinkService() {
    initDeepLinkListener();
  }

  void initDeepLinkListener() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      handleLink(initialUri);

      _appLinks.uriLinkStream.listen(handleLink, onError: (err) {
        log('Failed to handle link: $err');
      });
    } catch (e) {
      log('Error initializing deep link listener: $e');
    }
  }

  void handleLink(Uri? uri) {
    if (uri == null) return;

    log('Received deep link: $uri');

    // Extract the path segments
    final segments = uri.pathSegments
        .map((segment) => segment.replaceAll('/', ''))
        .toList();
    if (segments.isEmpty) {
      Get.toNamed('/');
      return;
    }

    final route = segments.first.toLowerCase();

    switch (route) {
      case 'surah':
        _navigateToMenuDetail('Surah');
        break;
      case 'dua':
        _navigateToMenuDetail('Dua');
        break;
      case 'daily-dua':
        _navigateToMenuDetail('Daily Dua');
        break;
      case 'ziyarat':
        _navigateToMenuDetail('Ziyarat');
        break;
      case 'amaal':
        _navigateToMenuDetail('Amaal');
        break;
      case 'amaal-namaz':
        _navigateToMenuDetail('Amaal & Namaz');
        break;
      case 'munajat':
        _navigateToMenuDetail('Munajat');
        break;
      case 'travel-ziyarat':
        _navigateToMenuDetail('Travel Ziyarat');
        break;
      default:
        Get.toNamed('/');
        break;
    }
  }

  void _navigateToMenuDetail(String menuItem) {
    log('------> $menuItem <------');
    _categoryListController
        .fetchCategoryData(menuItem.capitalizeFirst!, true)
        .then((_) {
      Get.to(() => MenuDetailView(
            menuItem: menuItem,
            selectedLanguage: 'English',
          ));
    });
  }
}
