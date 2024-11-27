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

import '../controllers/daily_date_controller.dart';
import '../controllers/prayer_time_controller.dart'; // To check internet connection

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  String selectedLanguage = 'English'; // Default language selection
  final animatedTextController = Get.put(AnimatedTextController());
  final menuListController = Get.put(MenuListController());
  final dailyDateController=Get.put(DailyDateController());
  final prayerTimeController=Get.put(PrayerTimeController());

  // Function to refresh data when pull-to-refresh is triggered
  Future<void> _refreshData() async {
    // Check internet connectivity before attempting to fetch data
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // If there's no internet, show an error message or try offline actions
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No internet connection. Please check your network.")),
      );
    } else {
      // If connected, call the method to fetch new data
      await animatedTextController.fetchTextData();
      dailyDateController.fetchDailyDate();
      prayerTimeController.fetchPrayerTimes(52.569500, -0.240530);
      menuListController.fetchMenuItems() ; // Assuming this method fetches new data
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        drawer: CustomDrawer(),
        backgroundColor: AppColors.backgroundBlue,
        body: RefreshIndicator(
          onRefresh: _refreshData, // Pull-to-refresh triggers _refreshData
          color: Colors.white, // Color of the refresh indicator
          child: CustomScrollView( // Use CustomScrollView for better handling
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
                              Scaffold.of(context).openDrawer(); // Open the drawer
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
                          }
                          else if (animatedTextController.animatedTextList.isEmpty) {
                            return const Center(
                              child: Text(
                                'No Data available',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          else {
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
              // Dropdown menu for language selection
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
                            style: TextStyle(fontSize: 18, color: Colors.white38),
                          ),
                        ],
                      ),
                      DropdownButton<String>(
                        value: selectedLanguage,
                        dropdownColor: AppColors.backgroundBlue,
                        items: <String>['English', 'Gujarati'].map((String value) {
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
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverFillRemaining(
                child: MenuListView(
                  selectedLanguage: selectedLanguage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
