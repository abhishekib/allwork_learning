import 'dart:developer';

import 'package:allwork/modals/api_response_handler.dart';
import 'package:allwork/providers/search_provider.dart';
import 'package:get/get.dart';

class SearchCustomController extends GetxController {
  final SearchProvider _provider = SearchProvider();
  var isLoading = false.obs;
  var hasSearched = false.obs;
  var apiResponse = ApiResponseHandler(data: {}, posts: []).obs;

  var keywords = ''.obs;
  var currentPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchSearchResults({required String keywords, required int page}) async {
    isLoading(true);
    hasSearched(true);
    try {
      final response = await _provider.fetchSearchResults(
        keywords: keywords,
        page: page,
      );
      apiResponse.value = response;
    } catch (e) {
      log('message: Failed to fetch search results: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch search results: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false); // Stop loading
    }
  }

  /// Resets the controller state to idle
  void resetSearch() {
    hasSearched(false); // Reset the searched flag
    apiResponse.value =
        ApiResponseHandler(data: {}, posts: []); // Clear results
  }
}
