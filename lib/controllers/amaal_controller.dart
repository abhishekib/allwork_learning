import 'package:allwork/utils/constants.dart';
import 'package:get/get.dart';
import 'package:allwork/modals/amaal_model.dart';
import 'package:allwork/providers/amaal_provider.dart';

class AmaalController extends GetxController {
  // Reactive variables
  var isLoading = true.obs;
  var amaalModel = AmaalModel().obs;
  var errorMessage = ''.obs;

  final AmaalProvider amaalProvider = AmaalProvider(ApiConstants.token);

  @override
  void onInit() {
    fetchAmaalData();
    super.onInit();
  }

  // Fetch Amaal data
  Future<void> fetchAmaalData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await amaalProvider.fetchAmaalData();
      amaalModel.value = data;
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Helper to get nested items
  List<dynamic> getItems(String category, String subCategory) {
    final data = amaalModel.value.data;
    if (data?[category] is Map<String, dynamic>) {
      return data?[category][subCategory] ?? [];
    }
    return [];
  }
}
