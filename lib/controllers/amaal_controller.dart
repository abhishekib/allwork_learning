import 'package:allwork/modals/amaal_model.dart';
import 'package:allwork/providers/amaal_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:get/get.dart';

class AmaalController extends GetxController {
  final AmaalProvider amaalProvider = AmaalProvider(ApiConstants.token);

  final isLoading = false.obs;
  final amaalData = Rxn<AmaalData>();
  final categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAmaal();
  }

  void fetchAmaal() async {
    isLoading.value = true;
    try {
      final data = await amaalProvider.fetchAmaalData();
      amaalData.value = data;

      // Process categories
      categories.value = amaalData.value!.data.entries.map((entry) {
        return Category.fromJson(entry.key, entry.value);
      }).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
