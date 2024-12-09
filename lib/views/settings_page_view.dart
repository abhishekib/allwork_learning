import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double arabicFontSize = 18.0;
  double transliterationFontSize = 16.0;
  double translationFontSize = 16.0;
  bool isCompactAudioView = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      arabicFontSize = prefs.getDouble('arabicFontSize') ?? 18.0;
      transliterationFontSize =
          prefs.getDouble('transliterationFontSize') ?? 16.0;
      translationFontSize = prefs.getDouble('translationFontSize') ?? 16.0;
      isCompactAudioView = prefs.getBool('isCompactView') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabicFontSize', arabicFontSize);
    await prefs.setDouble('transliterationFontSize', transliterationFontSize);
    await prefs.setDouble('translationFontSize', translationFontSize);
    await prefs.setBool('isCompactView', isCompactAudioView);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBlue,
          title: const Text(
            "Settings",
            style: AppTextStyles.whiteBoldTitleText,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Adjust Arabic Font Size",
                style: AppTextStyles.whiteBoldText,
              ),
              Slider(
                min: 18.0,
                max: 30.0,
                divisions: 16,
                value: arabicFontSize,
                onChanged: (value) {
                  setState(() {
                    arabicFontSize = value;
                  });
                },
              ),
              Text(
                "حجم الخط العربي: ${arabicFontSize.toStringAsFixed(1)}",
                style: TextStyle(
                  fontSize: arabicFontSize,
                  color: Colors.white,
                  fontFamily: "MUHAMMADI",
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Adjust Transliteration Font Size",
                style: AppTextStyles.whiteBoldText,
              ),
              Slider(
                min: 16.0,
                max: 30.0,
                divisions: 16,
                value: transliterationFontSize,
                onChanged: (value) {
                  setState(() {
                    transliterationFontSize = value;
                  });
                },
              ),
              Text(
                "Transliteration Font Size: ${transliterationFontSize.toStringAsFixed(1)}",
                style: TextStyle(
                  fontSize: transliterationFontSize,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Adjust Translation Font Size",
                style: AppTextStyles.whiteBoldText,
              ),
              Slider(
                min: 16.0,
                max: 30.0,
                divisions: 16,
                value: translationFontSize,
                onChanged: (value) {
                  setState(() {
                    translationFontSize = value;
                  });
                },
              ),
              Text(
                "Translation Font Size: ${translationFontSize.toStringAsFixed(1)}",
                style: TextStyle(
                  fontSize: translationFontSize,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Audio Player View",
                style: AppTextStyles.whiteBoldText,
              ),
              SwitchListTile(
                title: const Text(
                  "Compact View",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                value: isCompactAudioView,
                onChanged: (value) {
                  setState(() {
                    isCompactAudioView = value;
                  });
                },
                activeColor: Colors.white,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: AppColors.backgroundBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
