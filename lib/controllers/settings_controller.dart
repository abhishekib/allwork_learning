import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  var arabicFontSize = 30.0.obs;
  var transliterationFontSize = 23.0.obs;
  var translationFontSize = 21.3.obs;
  var isCompactAudioView = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arabicFontSize.value = prefs.getDouble('arabicFontSize') ?? arabicFontSize.value;
    transliterationFontSize.value = prefs.getDouble('transliterationFontSize') ?? transliterationFontSize.value;
    translationFontSize.value = prefs.getDouble('translationFontSize') ?? translationFontSize.value;
    isCompactAudioView.value = prefs.getBool('isCompactView') ?? true;
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabicFontSize', arabicFontSize.value);
    await prefs.setDouble('transliterationFontSize', transliterationFontSize.value);
    await prefs.setDouble('translationFontSize', translationFontSize.value);
    await prefs.setBool('isCompactView', isCompactAudioView.value);
  }

  void updateArabicFontSize(double size) {
    arabicFontSize.value = size;
    _saveSettings();
  }

  void updateTransliterationFontSize(double size) {
    transliterationFontSize.value = size;
    _saveSettings();
  }

  void updateTranslationFontSize(double size) {
    translationFontSize.value = size;
    _saveSettings();
  }

  void updateCompactAudioView(bool isCompact) {
    isCompactAudioView.value = isCompact;
    _saveSettings();
  }
}
