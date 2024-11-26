import 'package:allwork/modals/about_us_response.dart';
import 'package:allwork/providers/about_us_provider.dart';
import 'package:get/get.dart';
import 'package:allwork/utils/constants.dart';

class AboutUsController extends GetxController {
  final isLoading = false.obs;
  final aboutUsText = ''.obs;

  final AboutUsProvider _aboutUsProvider = AboutUsProvider(ApiConstants.token);

  @override
  void onInit() {
    super.onInit();
    fetchTextData();
  }

  Future<void> fetchTextData() async {
    try {
      isLoading(true);
      AboutUsResponse fetchedResponse = await _aboutUsProvider.getAboutUs();

      String cleanedText = removeHtmlTags(fetchedResponse.data);

      aboutUsText.value = cleanedText;
    } catch (e) {
      print('Error fetching About Us data: $e');
    } finally {
      isLoading(false);
    }
  }

  String removeHtmlTags(String htmlText) {
    final RegExp exp =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlText.replaceAll(exp, '');
  }
}
