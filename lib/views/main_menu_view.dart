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

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  String selectedLanguage = 'English'; // Default language selection

  @override
  Widget build(BuildContext context) {
    final animatedTextController = Get.put(AnimatedTextController());

    return BackgroundWrapper(
      child: Scaffold(
        drawer: CustomDrawer(),
        backgroundColor: AppColors.backgroundBlue,
        body: Column(
          children: [
            // Custom "AppBar" with Marquee and Drawer Icon
            Container(
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
                      else if(animatedTextController.animatedTextList.isEmpty){
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
            // const SizedBox(height: 10),
            SearchBarWidget(),
            // const SizedBox(height: 10),
            DailyDateWidget(),
            // const SizedBox(height: 10),
            PrayerTimeWidget(),
            // const SizedBox(height: 10),
            // Dropdown menu for language selection
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
            const SizedBox(height: 10),
            // Rest of the body with MenuListView
            Expanded(
              child: MenuListView(
                selectedLanguage: selectedLanguage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
