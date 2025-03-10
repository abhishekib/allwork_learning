import 'dart:developer';

import 'package:allwork/controllers/category_detail_controller.dart';
import 'package:allwork/controllers/deep_linking_controller.dart';
import 'package:allwork/controllers/favourite_controller.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/providers/deep_linking_provider.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/utils/constants.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/category_detail_view.dart';
import 'package:allwork/views/settings_page_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AmaalDetailsScreen extends StatefulWidget {
  final Category item;

  AmaalDetailsScreen({super.key, required this.item});

  @override
  State<AmaalDetailsScreen> createState() => _AmaalDetailsScreenState();
}

class _AmaalDetailsScreenState extends State<AmaalDetailsScreen> {
String menuItem = "Amaal";

  final DeepLinkingController deepLinkingController =
      Get.put(DeepLinkingController());

  final CategoryDetailController controller = Get.put(CategoryDetailController());

  @override
  Widget build(BuildContext context) {
    
    Get.put(FavouriteController());
    
    return BackgroundWrapper(
      child: Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          type: ExpandableFabType.fan,
          distance: 180,
          overlayStyle: ExpandableFabOverlayStyle(
            color: Colors.black.withOpacity(0.5),
            blur: 1,
          ),
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.menu),
            fabSize: ExpandableFabSize.small,
            shape: const CircleBorder(),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            child: const Icon(Icons.close),
            fabSize: ExpandableFabSize.small,
            shape: const CircleBorder(),
          ),
          children: [
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.share),
              onPressed: () {
                Share.shareUri(Uri.parse(widget.item.link!));
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.copy),
              onPressed: () {
                // Call the copy functionality from LyricsTab
                controller.copyAmaalDataToClipboard(
                    context, widget.item.data!, widget.item.title);
              },
            ),
            FloatingActionButton.small(
                heroTag: null,
                onPressed: () {
                  controller.handleAddToFavourite(context, widget.item,
                      menuItem, widget.item.isFav == "Yes" ? true : false);
                  setState(() {
                    widget.item.isFav =
                        widget.item.isFav == "Yes" ? "No" : "Yes";
                  });
                },
                child: Icon(Icons.favorite,
                    color: widget.item.isFav == "Yes"
                        ? Colors.red
                        : Colors.purple)), 
            /*
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.access_alarm),
              onPressed: () async {
                Duration duration = Duration(hours: 0, minutes: 0);
                showModalBottomSheet(
                    backgroundColor: Colors.white,
                    constraints: BoxConstraints.tight(Size.fromHeight(
                        MediaQuery.of(context).size.height * 0.40)),
                    context: context,
                    builder: (context) => Column(
                          children: [
                            CupertinoTimerPicker(
                              backgroundColor: CupertinoColors.white,
                              mode: CupertinoTimerPickerMode.hm,
                              onTimerDurationChanged: (value) {
                                log("Time selected: $value");
                                duration = value;
                              },
                            ),
                            //SizedBox(height: 20),
                            // Select Week Days with improved UI
                            SelectWeekDays(
                              onSelect: (List<String> values) {
                                log("Days List: $values");
                                controller.selectedDaysForReminder = values;
                              },
                              width: 320,
                              days: ApiConstants.days,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              backgroundColor: Colors.white,
                              selectedDayTextColor: Colors.white,
                              selectedDaysFillColor: AppColors.backgroundBlue,
                              unselectedDaysFillColor: Colors.white,
                              selectedDaysBorderColor: AppColors.backgroundBlue,
                              unselectedDaysBorderColor:
                                  AppColors.backgroundBlue,
                              unSelectedDayTextColor: AppColors.backgroundBlue,
                            ),

                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    AppColors.backgroundBlue),
                              ),
                              onPressed: () {
                                Get.back();
                                Get.snackbar(
                                    "Reminder", "Reminder set up successfully");
                                controller.scheduleNotification(
                                    categoryDetails, duration);
                              },
                              child: const Text(
                                "Set Reminder",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ));
              },
            ),
            */
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.settings),
              onPressed: () {
                Get.to(SettingsPage());
              },
            ),
          ],
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              TextCleanerService.cleanText(widget.item.title),
              style: AppTextStyles.whiteBoldTitleText,
            ),
          ),
        ),
        body: Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              // Make content scrollable
              child: Html(
                data: widget.item.data!,
                onLinkTap: (String? url, _, __) async {
                  if (url != null) {
                    final uri = Uri.parse(url);
                    try {
                      deepLinkingController.handleDeepLink(url);
                    } catch (e) {
                      debugPrint('Could not launch $url: $e');
                    }
                  }
                },
                style: {
                  "p": Style(
                    fontSize: FontSize(16.0),
                    fontWeight: FontWeight.w500,
                  ),
                  "br": Style(
                    display: Display.block,
                    margin: Margins.only(bottom: 10), // Corrected Margins
                  ),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
