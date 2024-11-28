import 'package:allwork/controllers/menu_list_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/views/menu_list_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:allwork/widgets/custom_drawer.dart';
import 'package:allwork/widgets/daily_date_widget.dart';
import 'package:allwork/widgets/marquee_appbar.dart';
import 'package:allwork/widgets/prayer_time_widget.dart';
import 'package:allwork/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/animated_text_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/daily_date_controller.dart';
import '../controllers/prayer_time_controller.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  String selectedLanguage = 'English';
  final animatedTextController = Get.put(AnimatedTextController());
  final menuListController = Get.put(MenuListController());
  final dailyDateController = Get.put(DailyDateController());
  final prayerTimeController = Get.put(PrayerTimeController());

  Future<void> _refreshData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("No internet connection. Please check your network.")),
      );
    } else {
      await animatedTextController.fetchTextData();
      dailyDateController.fetchDailyDate();
      prayerTimeController.fetchPrayerTimes(52.569500, -0.240530);
      menuListController.fetchMenuItems();
    }
  }

  Future<void> _saveLanguagePreference(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        drawer: CustomDrawer(),
        backgroundColor: AppColors.backgroundBlue,
        body: RefreshIndicator(
          onRefresh: _refreshData,
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.backgroundBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),
                      Expanded(
                        child: Obx(() {
                          if (animatedTextController.isLoading.value) {
                            return Container(
                              height: 50.0,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
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
                            return MarqueeTextWidget(
                              marqueeTexts: marqueeTexts,
                            );
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SearchBarWidget()),
              SliverToBoxAdapter(child: DailyDateWidget()),
              SliverToBoxAdapter(child: PrayerTimeWidget()),
              SliverToBoxAdapter(
                child: Padding(
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
                            style:
                                TextStyle(fontSize: 18, color: Colors.white38),
                          ),
                        ],
                      ),
                      DropdownButton<String>(
                        value: selectedLanguage,
                        dropdownColor: AppColors.backgroundBlue,
                        items:
                            <String>['English', 'Gujarati'].map((String value) {
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
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: MenuListView(selectedLanguage: selectedLanguage),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
