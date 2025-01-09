import 'package:allwork/controllers/popup_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/views/menu_list_view.dart';
import 'package:allwork/views/search_page.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:allwork/widgets/custom_drawer.dart';
import 'package:allwork/widgets/daily_date_widget.dart';
import 'package:allwork/widgets/marquee_appbar.dart';
import 'package:allwork/widgets/prayer_time_widget.dart';
import 'package:allwork/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/animated_text_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  MainMenuViewState createState() => MainMenuViewState();
}

class MainMenuViewState extends State<MainMenuView> {
  String selectedLanguage = 'English';
  final animatedTextController = Get.put(AnimatedTextController());
  final popupController = Get.put(PopupController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _saveLanguagePreference(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    popupController
        .fetchAmalNamazPopup()
        .then((_) => popupController.fetchEventPopup())
        .then((_) => popupController.fetchStartPopup());
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        body: Column(
          children: [
            // Static content that should not scroll
            Container(
              color: AppColors.backgroundBlue,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      // Scaffold.of(context).openDrawer();
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  Expanded(
                    child: Obx(() {
                      if (animatedTextController.isLoading.value) {
                        return Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else if (animatedTextController
                          .animatedTextList.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Data available',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        final marqueeTexts = animatedTextController
                            .animatedTextList
                            .map((text) => text)
                            .toList();
                        return MarqueeTextWidget(marqueeTexts: marqueeTexts);
                      }
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  GestureDetector(
                    child: SearchBarWidget(),
                    onTap: () {
                      Get.to(() => SearchPage());
                    },
                  ),
                  DailyDateWidget(),
                  PrayerTimeWidget(),

                  // Language selection dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              selectedLanguage == 'English'
                                  ? 'Language Selection : '
                                  : 'ભાષા પસંદગી : ',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'English & ગુજરાતી',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white38),
                            ),
                          ],
                        ),
                        DropdownButton<String>(
                          value: selectedLanguage,
                          dropdownColor: AppColors.backgroundBlue,
                          items: <String>['English', 'ગુજરાતી']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLanguage = newValue!;
                              _saveLanguagePreference(selectedLanguage);
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  MenuListView(selectedLanguage: selectedLanguage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
