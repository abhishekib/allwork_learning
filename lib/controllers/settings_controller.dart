import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  var arabicFontSize = 35.0.obs;
  var transliterationFontSize = 23.0.obs;
  var translationFontSize = 21.3.obs;
  var isCompactAudioView = false.obs;

  var fontList = <String>[].obs;
  var arabicFontFamily = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arabicFontSize.value =
        prefs.getDouble('arabicFontSize') ?? arabicFontSize.value;
    transliterationFontSize.value =
        prefs.getDouble('transliterationFontSize') ??
            transliterationFontSize.value;
    translationFontSize.value =
        prefs.getDouble('translationFontSize') ?? translationFontSize.value;
    isCompactAudioView.value = prefs.getBool('isCompactView') ?? true;
    arabicFontFamily.value =
        prefs.getString('arabicFontFamily') ?? '';
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabicFontSize', arabicFontSize.value);
    await prefs.setDouble(
        'transliterationFontSize', transliterationFontSize.value);
    await prefs.setDouble('translationFontSize', translationFontSize.value);
    await prefs.setBool('isCompactView', isCompactAudioView.value);
    await prefs.setString('arabicFontFamily',
        arabicFontFamily.value);
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

  Future<void> selectFonts() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['ttf', 'otf'],
        allowMultiple: true);

    if (result != null) {
      for (var file in result.files) {
        final fontFile = File(file.path!);
        final fontBytes = await fontFile.readAsBytes();

        final fontLoader = FontLoader(file.name)
          ..addFont(Future.value(ByteData.sublistView(fontBytes)));

        await fontLoader.load();
        fontList.add(file.name);
      }
      _saveSettings();
    }
  }

  void applyFont(String fontName) {
    arabicFontFamily.value = fontName; 
    _saveSettings();
  }

  void removeFont(String fontName) {
    fontList.remove(fontName);
    _saveSettings();
  }
}
