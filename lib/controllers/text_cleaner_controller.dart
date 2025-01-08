import 'package:get/get.dart';

class TextCleanerController extends GetxController {
  String cleanText(String input) {
    String cleanedText = input.replaceAll(RegExp(r'<[^>]*>'), '');
    cleanedText = cleanedText.replaceAll(RegExp(r'&[#\w\d]+;'), '');
    cleanedText = cleanedText.replaceAll('&nbsp;', '');
    cleanedText = cleanedText.replaceAll(':nbsp&', '');
    cleanedText = cleanedText.replaceAll('&#8211;', '');
    cleanedText = cleanedText.replaceAll('&#8217;', '');

    return cleanedText.trim();
  }
}
