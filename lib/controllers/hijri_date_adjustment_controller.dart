import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HijriDateAdjustmentController extends GetxController {
  final List<String> hijriDateAdjustment = [
    '-4',
    '-3',
    '-2',
    '-1',
    '0',
    '1',
    '2',
    '3',
    '4'
  ];

  RxString selectedAdjustment = RxString('0');

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> setSelectedAdjustment(String value) async {
    selectedAdjustment.value = value;
  }

  void closeDialogue() {
    Get.back();
  }

}
