import 'dart:developer';

import 'package:allwork/modals/amal_namaz_popup_model.dart';
import 'package:allwork/modals/event_popup_model.dart';
import 'package:allwork/providers/popup_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:allwork/utils/popupEnums.dart';
import 'package:allwork/views/popup_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopupController extends GetxController {
  final isVisible = false.obs;
  final Rx<EventPopupModel?> eventPopupModel = Rx<EventPopupModel?>(null);
  final Rx<AmalNamazPopupModel?> amalNamazPopupModel =
      Rx<AmalNamazPopupModel?>(null);

  final PopupProvider _eventPopupProvider = PopupProvider(ApiConstants.token);

  Future<void> fetchStartPopup() async {
    // Obtain shared preferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Log the current state of 'startedPreviously'
    bool startedPreviously = prefs.getBool('startedPreviously') ?? false;
    log("Stated previously from shared preferences is $startedPreviously");

    // Check if the app hasn't been started previously
    if (!startedPreviously) {
      // Mark 'startedPreviously' as true
      await prefs.setBool('startedPreviously', true);

      // Show the start popup
      Get.dialog(PopupView(PopupType.START_POPUP), barrierDismissible: true);
    }
  }

  Future<void> fetchAmalNamazPopup() async {
    try {
      final response = await _eventPopupProvider.getAmalNamazPopup();
      if (response != null) {
        if(response.data.isNotEmpty) {
          amalNamazPopupModel.value = response;
          isVisible.value = true;
          log("Event Popup Data: $response");

          // Show the event popup dialog
          Get.dialog(PopupView(PopupType.AMAL_NAMAZ_POPUP),
              barrierDismissible: true);
        }
      } else {
        // eventPopupModel.value = null;
        isVisible.value = false;
        log("No valid event data found.");
      }
    } catch (e) {
      //eventPopupModel.value = null;
      isVisible.value = false;
      log('Error fetching event popup: $e');
    }
  }

  Future<void> fetchEventPopup() async {
    try {
      final response = await _eventPopupProvider.getEventPopup();
      if (response != null) {
        if (response.imageUrl != null) {
          eventPopupModel.value = response;
          isVisible.value = true;
          log("Event Popup Data: $response");

          // Show the event popup dialog
          Get.dialog(PopupView(PopupType.EVENT_POPUP),
              barrierDismissible: true);
        }
      } else {
        eventPopupModel.value = null;
        isVisible.value = false;
        log("No valid event data found.");
      }
    } catch (e) {
      //eventPopupModel.value = null;
      isVisible.value = false;
      log('Error fetching event popup: $e');
    }
  }

  void closeBanner() {
    isVisible.value = false;
    Get.back(); // Close the popup by popping the dialog
  }
}
